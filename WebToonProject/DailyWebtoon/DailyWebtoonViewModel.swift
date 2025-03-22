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

final class DailyWebtoonViewModel: BaseViewModel {

    // for pagination
    private var currentPage = 1
    private var currentDay = Resources.WeekDay.today
    private var hasNextPage = true
    private var resultToShow: [Webtoon] = []

    let isLoading = BehaviorRelay<Bool>(value: false)
    let resultList = PublishRelay<[Webtoon]>()
    private let errorMessage = PublishRelay<CustomError>()

    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger: PublishRelay<Void>
        let dayButtonTapped: Observable<Resources.WeekDay>
        let reachedBottom: Observable<Void>
    }
    
    struct Output {
        let resultList: Driver<[Webtoon]>
        let errorMessage: PublishRelay<CustomError>
    }
    
    func transform(_ input: Input) -> Output {
        input.dayButtonTapped
            .do(onNext: { [weak self] _ in
                let shimmer = Webtoon.shimmer
                self?.resultList.accept(Array(repeating: shimmer, count: 12))
            })
            .bind(with: self) { owner, day in
                owner.resultToShow = []
                owner.currentPage = 1
                owner.currentDay = day
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
        print(#function, currentDay)
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
                self.resultList.accept(self.resultToShow)
            case .failure(let error):
                self.errorMessage.accept(error)
            }
        }
    }
}
