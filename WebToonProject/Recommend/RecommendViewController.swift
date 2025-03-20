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
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = recommendView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Resources.Keys.Title.recommend.rawValue.localized
        
        configureBannerView()
        configureCollectionView()
        
        bind()
    }
    
    private func bind() {
        let input = RecommendViewModel.Input()
        let output = recommendViewModel.transform(input)
        
        output.resultList
            .do { resultList in
                if resultList.isEmpty {
                    self.showAlert(title: "alert title",
                                   message: "alert message")
                }
            }
            .drive(recommendView.collectionView.rx.items(
                cellIdentifier: BasicCollectionViewCell.identifier,
                cellType: BasicCollectionViewCell.self)) { index, item, cell in
                    cell.configureData(item)
                }
                .disposed(by: disposeBag)
    }

}

// MARK: - BannerView
extension RecommendViewController {
    
    private func configureBannerView() {
        let images = [
            UIImage(named: "Image001")!,
            UIImage(named: "Image002")!,
            UIImage(named: "Image003")!,
            UIImage(named: "Image004")!,
            UIImage(named: "Image005")!
        ]
        recommendView.bannerView.setImages(images)
    }
}

// MARK: - DailyButton
extension RecommendViewController {
    
}

// MARK: - CollectionView
extension RecommendViewController {
    
    private func configureCollectionView() {
        recommendView.collectionView.register(UINib(nibName: "BasicCollectionViewCell", bundle: nil),
                                              forCellWithReuseIdentifier: BasicCollectionViewCell.identifier)

    }
}
