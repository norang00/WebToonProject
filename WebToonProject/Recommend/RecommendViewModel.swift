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
    
    private let resultList = PublishRelay<[Webtoon]>()
    private let errorMessage = PublishRelay<CustomError>()

    // internal use
    private let page = 1
    
    private let disposeBag = DisposeBag()
    
    struct Input {
    }
    
    struct Output {
        let resultList: Driver<[Webtoon]>
        let errorMessage: PublishRelay<CustomError>
    }
    
    func transform(_ input: Input) -> Output {

        fetchData()

        
        return Output(
            resultList: resultList.asDriver(onErrorJustReturn: []),
            errorMessage: errorMessage
        )
    }
    
    private func fetchData() {
        callRequestToNetworkManager()
    }
     
    
    private func callRequestToNetworkManager() {
        let api = NetworkRequest.webtoon(keyword: nil, page: page, sort: nil, isUpdated: nil, isFree: nil, day: nil)
        NetworkManager.shared.callRequestToAPIServer(api, Welcome.self) { [weak self] response in
            switch response {
            case .success(let data):
                self?.resultList.accept(data.webtoons)
                dump(data)
            case .failure(let error):
                print(error)
                self?.errorMessage.accept(error)
            }
        }
    }
    
}
