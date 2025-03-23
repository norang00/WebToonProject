//
//  ImageViewerViewModel.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/22/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ImageViewerViewModel: BaseViewModel<Image,
                                  ImageViewerViewModel.Input,
                                  ImageViewerViewModel.Output> {
    
    var imageKeyword: String = ""
    
    struct Input {
        let viewDidLoadTrigger: PublishRelay<Void>
    }
    
    struct Output {
        let resultList: Driver<[Image]>
        let errorMessage: PublishRelay<CustomError>
    }
    
    override func transform(_ input: Input) -> Output {
        input.viewDidLoadTrigger
            .bind(with: self) { owner, _ in
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
        
        let option = ImageRequestOption(
            keyword: imageKeyword,
            display: Int.random(in: 20...100)
        )
        let api = NetworkRequest.image(option: option)
        
        print(#function, option)
        
        NetworkManager.shared.callRequestToAPIServer(api, ImageData.self) { [weak self] response in
            guard let self else { return }
            isLoading.accept(false)
            
            switch response {
            case .success(let data):
                self.resultToShow = data.items
                self.resultList.accept(resultToShow)
                dump(data.items.first!)
            case .failure(let error):
                self.errorMessage.accept(error)
            }
        }
    }
}
