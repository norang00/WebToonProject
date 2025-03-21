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
    private let page = 1
    
    private let resultList = PublishRelay<[Webtoon]>()
    private let errorMessage = PublishRelay<CustomError>()

    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchClicked: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let resultList: Driver<[Webtoon]>
        let errorMessage: PublishRelay<CustomError>
    }
    
    func transform(_ input: Input) -> Output {
        input.searchClicked
            .debug("searchClicked")
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .bind(with: self) { owner, keyword in
                let value = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
                if !value.isEmpty {
                    print(keyword)
                    owner.callRequest(keyword)
                } else {
                    print("no query")
                }
            }
            .disposed(by: disposeBag)

        return Output(
            resultList: resultList.asDriver(onErrorJustReturn: []),
            errorMessage: errorMessage
        )
    }
    
    private func callRequest(_ keyword: String) {
        print(#function, keyword)
        let api = NetworkRequest.webtoon(keyword: keyword, page: page, sort: nil, isUpdated: nil, isFree: nil, day: nil)
        NetworkManager.shared.callRequestToAPIServer(api, WebToonData.self) { [weak self] response in
            switch response {
            case .success(let data):
                self?.resultList.accept(data.webtoons)
                print("callRequest - parameters", api.parameters)
                print("callRequest - success", data.webtoons.count)
                dump(data.webtoons)
            case .failure(let error):
                print("callRequest - error", error)
                self?.errorMessage.accept(error)
            }
        }
    }
}
