//
//  RecommendViewModel.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class RecommendViewModel: BaseViewModel<Webtoon,
                                RecommendViewModel.Input,
                                RecommendViewModel.Output> {
    
    private let bannerImages = PublishRelay<[UIImage]>()

    
    struct Input {
        let viewDidLoadTrigger: PublishRelay<Void>
        let fetchBannerImagesTrigger: PublishRelay<Void>
    }
    
    struct Output {
        let bannerImages: Driver<[UIImage]>
        let resultList: Driver<[Webtoon]>
        let errorMessage: PublishRelay<CustomError>
    }
    
    override func transform(_ input: Input) -> Output {
        input.viewDidLoadTrigger
            .bind(with: self) { owner, _ in
                let shimmer = Webtoon.shimmer
                owner.resultList.accept(Array(repeating: shimmer, count: 6))
                owner.callRequestToNetworkManager()
            }
            .disposed(by: disposeBag)

        input.fetchBannerImagesTrigger
            .flatMapLatest { [weak self] _ -> Observable<[UIImage]> in
                guard let self = self else { return .just([]) }
                return self.fetchBannerImages()
            }
            .bind(to: bannerImages)
            .disposed(by: disposeBag)
        
        return Output(
            bannerImages: bannerImages.asDriver(onErrorJustReturn: []),
            resultList: resultList.asDriver(onErrorJustReturn: []),
            errorMessage: errorMessage
        )
    }
    
    private func callRequestToNetworkManager() {
        let option = WebtoonRequestOption(isUpdated: true)
        let api = NetworkRequest.webtoon(option: option)
        NetworkManager.shared.callRequestToAPIServer(api, WebToonData.self) { [weak self] response in
            switch response {
            case .success(let data):
                self?.resultList.accept(data.webtoons.shuffled())
            case .failure(let error):
                self?.errorMessage.accept(error)
            }
        }
    }
}

// MARK: - BannerView
extension RecommendViewModel {
    
    private func fetchBannerImages() -> Observable<[UIImage]> {
        print(#function)
        // CDN 에서 URL 로 이미지 받아오는 환경을 가정
        let imageURLs = [
            "https://cdn-manga-stf-router-api.line-scdn.net/top_banner/RbHgV4TPYS8hIkeoP8Sy44Fu.png",
            "https://cdn-manga-stf-router-api.line-scdn.net/indies_top_banner/UeInm0TPQlbo3JTBrqF2eRhu.png",
            "https://cdn-manga-stf-router-api.line-scdn.net/indies_top_banner/qvjneBj6CbSx1IfOT8I8NZGp.png"
        ]
        
        // [CHECK]
        // images.append(value.image)가 비동기적으로 실행되는 Kingfisher 내부에서 여러 번 호출될 수 있음.
        // Serial DispatchQueue를 사용하면 동기적으로 실행되므로 Data Race가 방지됨.
        let syncQueue = DispatchQueue(label: "syncQueue")

        return Observable.create { observer in
            var images: [UIImage] = []
            let group = DispatchGroup()
            
            for urlString in imageURLs {
                if let url = URL(string: urlString) {
                    group.enter()
                    KingfisherManager.shared.retrieveImage(with: url) { result in
                        switch result {
                        case .success(let value):
                            syncQueue.sync {
                                images.append(value.image)
                                print("images", images)
                            }
                        case .failure(let error):
                            print("failed to load image: \(error.localizedDescription)")
                        }
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                observer.onNext(images)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
