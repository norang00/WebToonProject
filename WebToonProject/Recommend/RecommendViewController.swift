//
//  RecommendViewController.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit
import RxSwift
import RxCocoa

final class RecommendViewController: BaseViewController {

    private let recommendView = RecommendView()
    private let recommendViewModel = RecommendViewModel()
    
    private let viewDidLoadTrigger = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = recommendView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Resources.Keys.recommend.rawValue.localized
        configureCollectionView()
        
        bind()
        viewDidLoadTrigger.accept(())
    }
    
    private func bind() {
        let input = RecommendViewModel.Input(
            viewDidLoadTrigger: viewDidLoadTrigger,
            fetchBannerImagesTrigger: viewDidLoadTrigger
        )
        let output = recommendViewModel.transform(input)
        
        output.resultList
            .drive(recommendView.collectionView.rx.items(
                cellIdentifier: BasicCollectionViewCell.identifier,
                cellType: BasicCollectionViewCell.self)) { index, item, cell in
                    if item.title == "__shimmer__" {
                        cell.showShimmer()
                    } else {
                        cell.hideShimmer()
                        cell.configureData(item)
                    }
                }
                .disposed(by: disposeBag)

        output.bannerImages
            .drive(onNext: { [weak self] images in
                self?.recommendView.bannerView.setImages(images)
            })
            .disposed(by: disposeBag)
    }
}
// MARK: - DailyButton
extension RecommendViewController {
    
}

// MARK: - CollectionView
extension RecommendViewController {
    
    private func configureCollectionView() {
        recommendView.collectionView.register(UINib(nibName: BasicCollectionViewCell.identifier, bundle: nil),
                                              forCellWithReuseIdentifier: BasicCollectionViewCell.identifier)

    }
}
