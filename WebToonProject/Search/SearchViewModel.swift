//
//  SearchViewModel.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/20/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: BaseViewModel {
    

    // for pagination
    private var currentPage = 1
    private var hasNextPage = true
    private var currentKeyword = ""
    private var resultToShow: [Webtoon] = []
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let resultList = PublishRelay<[Webtoon]>()
    private let errorMessage = PublishRelay<CustomError>()

    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchClicked: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let reachedBottom: Observable<Void>
    }
    
    struct Output {
        let resultList: Driver<[Webtoon]>
        let errorMessage: PublishRelay<CustomError>
    }
    
    func transform(_ input: Input) -> Output {
        input.searchClicked
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .bind(with: self) { owner, keyword in
                owner.currentKeyword = keyword
                owner.currentPage = 1
                owner.resultToShow = []
                owner.hasNextPage = true
                owner.callRequestToNetworkManager(owner.currentKeyword, owner.currentPage)
            }
            .disposed(by: disposeBag)
        
        input.reachedBottom
            .bind(with: self) { owner, _ in
                if owner.isLoading.value || !owner.hasNextPage {
                    print("owner.isLoading", owner.isLoading.value)
                    print("owner.hasNextPage", owner.hasNextPage)
                    return
                }
                owner.currentPage += 1
                owner.callRequestToNetworkManager(owner.currentKeyword, owner.currentPage)
            }
            .disposed(by: disposeBag)

        return Output(
            resultList: resultList.asDriver(onErrorJustReturn: []),
            errorMessage: errorMessage
        )
    }
    
    private func callRequestToNetworkManager(_ keyword: String, _ page: Int) {
        isLoading.accept(true)
        let api = NetworkRequest.searchWebtoon(keyword: keyword, page: currentPage,
                                               isUpdated: nil, isFree: nil)
        NetworkManager.shared.callRequestToAPIServer(api, WebToonData.self) { [weak self] response in
            guard let self else { return }
            isLoading.accept(false)
            switch response {
            case .success(let data):
                self.resultToShow.append(contentsOf: data.webtoons)
                self.resultList.accept(self.resultToShow)
                self.hasNextPage = !data.isLastPage
            case .failure(let error):
                self.errorMessage.accept(error)
            }
        }
    }
}
