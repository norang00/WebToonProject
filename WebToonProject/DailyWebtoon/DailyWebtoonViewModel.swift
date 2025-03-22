//
//  DailyWebtoonViewModel.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/22/25.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class DailyWebtoonViewModel: BaseViewModel<Webtoon,
                                   DailyWebtoonViewModel.Input,
                                   DailyWebtoonViewModel.Output> {
    
    private var currentDay = Resources.WeekDay.today
    private var cachedResult: [Resources.WeekDay: [Webtoon]] = [:]
    
    struct Input {
        let viewDidLoadTrigger: PublishRelay<Void>
        let dayButtonTapped: Observable<Resources.WeekDay>
        let reachedBottom: Observable<Void>
    }
    
    struct Output {
        let resultList: Driver<[Webtoon]>
        let errorMessage: PublishRelay<CustomError>
    }
    
    override func transform(_ input: Input) -> Output {
        input.dayButtonTapped
            .withUnretained(self)
            .do(onNext: { owner, tappedDay in
                if let cached = owner.cachedResult[tappedDay] {
                    owner.resultList.accept(cached)
                } else {
                    owner.resultList.accept(Array(repeating: Webtoon.shimmer, count: 12))
                }
            })
            .filter { owner, tappedDay in
                return owner.cachedResult[tappedDay] == nil
            }
            .map { $0.1 }
            .bind(with: self) { owner, tappedDay in
                owner.resetPagination()
                owner.currentDay = tappedDay
                owner.callRequestToNetworkManager()
            }
            .disposed(by: disposeBag)
        
        input.viewDidLoadTrigger
            .do(onNext: { [weak self] _ in
                let shimmer = Webtoon.shimmer
                self?.resultList.accept(Array(repeating: shimmer, count: 12))
            })
            .bind(with: self) { owner, _ in
                owner.callRequestToNetworkManager()
            }
            .disposed(by: disposeBag)
        
        // pagination
        input.reachedBottom
            .bind(with: self) { owner, _ in
                if owner.isLoading.value || !owner.hasNextPage { return }
                owner.currentPage += 1
                owner.callRequestToNetworkManager()
            }
            .disposed(by: disposeBag)
        
        return Output(
            resultList: resultList.asDriver(onErrorJustReturn: []),
            errorMessage: errorMessage
        )
    }
    
    private func callRequestToNetworkManager() {
        isLoading.accept(true)
        
        let option = WebtoonRequestOption(
            page: currentPage,
            updateDay: currentDay?.code
        )
        let api = NetworkRequest.webtoon(option: option)
        
        NetworkManager.shared.callRequestToAPIServer(api, WebToonData.self) { [weak self] response in
            guard let self else { return }
            isLoading.accept(false)
            
            switch response {
            case .success(let data):
                self.resultToShow.append(contentsOf: data.webtoons)
                self.cachedResult[self.currentDay ?? .sun] = self.resultToShow
                self.resultList.accept(self.resultToShow)
                self.hasNextPage = !data.isLastPage
            case .failure(let error):
                self.errorMessage.accept(error)
            }
        }
    }
}
