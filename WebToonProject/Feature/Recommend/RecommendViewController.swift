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
    
    override func loadView() {
        view = recommendView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Resources.Keys.recommend.localized
        
        bind()
        viewDidLoadTrigger.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        output.resultList
            .delay(.milliseconds(100))
            .drive(with: self) { owner, _ in
                owner.recommendView.updateCollectionViewHeight()
            }
            .disposed(by: disposeBag)

        output.bannerImages
            .drive(onNext: { [weak self] images in
                self?.recommendView.bannerView.setImages(images)
            })
            .disposed(by: disposeBag)
        
        output.errorMessage
            .bind(with: self) { owner, customError in
                owner.showAlert(title: customError.title,
                                message: customError.message)
            }
            .disposed(by: disposeBag)
        
        recommendView.dailyButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = DailyWebtoonViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        recommendView.collectionView.rx.modelSelected(Webtoon.self)
            .bind(with: self) { owner, item in
                let nextVC = ImageViewerViewController()
                nextVC.webtoon = item
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        recommendView.collectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                owner.recommendView.collectionView.deselectItem(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
