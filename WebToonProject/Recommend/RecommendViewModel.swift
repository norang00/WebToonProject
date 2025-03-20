//
//  RecommendViewModel.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import Foundation
import RxSwift
import RxCocoa

final class RecommendViewModel: BaseViewModel {
    
    // internal use
    private let page = 1
    
    private let resultList = PublishRelay<[Webtoon]>()
    private let errorMessage = PublishRelay<CustomError>()
    
    private let disposeBag = DisposeBag()
    
    struct Input {
    }
    
    struct Output {
        let resultList: Driver<[Webtoon]>
        let errorMessage: PublishRelay<CustomError>
    }
    
    func transform(_ input: Input) -> Output {
        callRequest() // init
        
        return Output(
            resultList: resultList.asDriver(onErrorJustReturn: []),
            errorMessage: errorMessage
        )
    }
    
    private func callRequest() {
        let api = NetworkRequest.webtoon(keyword: nil, page: page, sort: nil, isUpdated: nil, isFree: nil, day: nil)
        NetworkManager.shared.callRequestToAPIServer(api, WebToonData.self) { [weak self] response in
            switch response {
            case .success(let data):
                self?.resultList.accept(data.webtoons)
            case .failure(let error):
                self?.errorMessage.accept(error)
            }
        }
    }
    
}
