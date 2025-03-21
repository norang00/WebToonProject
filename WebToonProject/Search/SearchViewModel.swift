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

    struct SearchOption {
        var isFree: Bool?
        var isUpdated: Bool?
    }
    
    // for pagination
    private var currentPage = 1
    private var hasNextPage = true
    private var currentKeyword = ""
    private var resultToShow: [Webtoon] = []
    private var currentSearchOption: SearchOption? = nil
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let resultList = PublishRelay<[Webtoon]>()
    private let errorMessage = PublishRelay<CustomError>()

    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchClicked: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let filterButtonTapped: Observable<FilterType>
        let authorButtonTapped: Observable<String>
        let reachedBottom: Observable<Void>
    }
    
    struct Output {
        let resultList: Driver<[Webtoon]>
        let errorMessage: PublishRelay<CustomError>
    }
    
    func transform(_ input: Input) -> Output {
        // search clicked
        input.searchClicked
            .withLatestFrom(input.searchText)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(with: self) { owner, keyword in
                owner.currentKeyword = keyword
                owner.currentPage = 1
                owner.resultToShow = []
                owner.hasNextPage = true
                owner.currentSearchOption = nil
                owner.resultList.accept(Array(repeating: Webtoon.shimmer, count: 5))
                owner.callRequestToNetworkManager(owner.currentKeyword, owner.currentPage)
            }
            .disposed(by: disposeBag)
        
        // filter button tapped
        input.filterButtonTapped
            .debug("filterButtonTapped")
            .bind(with: self) { owner, filter in
                owner.currentKeyword = ""
                owner.currentPage = 1
                owner.resultToShow = []
                owner.hasNextPage = true
                let option: SearchOption
                switch filter {
                case .isFree:
                    option = SearchOption(isFree: true, isUpdated: nil)
                case .isUpdated:
                    option = SearchOption(isFree: nil, isUpdated: true)
                }
                owner.currentSearchOption = option
                owner.resultList.accept(Array(repeating: Webtoon.shimmer, count: 5))
                owner.callRequestToNetworkManager(owner.currentKeyword, owner.currentPage, option)
            }
            .disposed(by: disposeBag)
        
        
        // author button tapped
        input.authorButtonTapped
            .debug("authorButtonTapped")
            .bind(with: self) { owner, author in
                owner.currentKeyword = author
                owner.currentPage = 1
                owner.resultToShow = []
                owner.hasNextPage = true
                owner.currentSearchOption = nil
                owner.resultList.accept(Array(repeating: Webtoon.shimmer, count: 5))
                owner.callRequestToNetworkManager(author, owner.currentPage)
            }
            .disposed(by: disposeBag)
        
        // pagination
        input.reachedBottom
            .bind(with: self) { owner, _ in
                if owner.isLoading.value || !owner.hasNextPage { return }
                owner.currentPage += 1
                owner.callRequestToNetworkManager(owner.currentKeyword, owner.currentPage, owner.currentSearchOption)
            }
            .disposed(by: disposeBag)

        return Output(
            resultList: resultList.asDriver(onErrorJustReturn: []),
            errorMessage: errorMessage
        )
    }
    
    private func callRequestToNetworkManager(_ keyword: String, _ page: Int, _ option: SearchOption? = nil) {
        isLoading.accept(true)

        let api = NetworkRequest.searchWebtoon(
            keyword: keyword,
            page: currentPage,
            isUpdated: option?.isUpdated,
            isFree: option?.isFree
        )

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
