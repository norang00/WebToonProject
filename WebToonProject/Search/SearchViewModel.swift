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

    struct Filter {
        var isFree: Bool?
        var isUpdated: Bool?
    }
    
    // for pagination
    private var currentPage = 1
    private var hasNextPage = true
    private var currentKeyword = ""
    private var resultToShow: [Webtoon] = []
    private var currentSearchOption: Filter? = nil
    
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
                owner.callRequestToNetworkManager()
            }
            .disposed(by: disposeBag)
        
        input.filterButtonTapped
            .bind(with: self) { owner, filter in
                owner.currentKeyword = ""
                owner.currentPage = 1
                owner.resultToShow = []
                owner.hasNextPage = true
                let option: Filter
                switch filter {
                case .isFree:
                    option = Filter(isFree: true, isUpdated: nil)
                case .isUpdated:
                    option = Filter(isFree: nil, isUpdated: true)
                }
                owner.currentSearchOption = option
                owner.resultList.accept(Array(repeating: Webtoon.shimmer, count: 5))
                owner.callRequestToNetworkManager()
            }
            .disposed(by: disposeBag)
        
        input.authorButtonTapped
            .bind(with: self) { owner, author in
                owner.currentKeyword = author
                owner.currentPage = 1
                owner.resultToShow = []
                owner.hasNextPage = true
                owner.currentSearchOption = nil
                owner.resultList.accept(Array(repeating: Webtoon.shimmer, count: 5))
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
            keyword: currentKeyword,
            page: currentPage,
            isUpdated: currentSearchOption?.isUpdated,
            isFree: currentSearchOption?.isFree
        )
        let api = NetworkRequest.webtoon(option: option)
        
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
