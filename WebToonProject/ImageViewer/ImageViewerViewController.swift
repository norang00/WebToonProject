//
//  ImageViewerViewController.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/22/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ImageViewerViewController: BaseViewController {
    
    var imageKeyword: String = ""

    private let imageViewerView = ImageViewerView()
    private let imageViewerViewModel = ImageViewerViewModel()
    
    private let viewDidLoadTrigger = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    override func loadView() {
        view = imageViewerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("ImageViewerViewController", #function, imageKeyword)

        imageViewerView.titleLabel.text = imageKeyword

        bind()
        viewDidLoadTrigger.accept(())

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func bind() {
        let input = ImageViewerViewModel.Input(
            viewDidLoadTrigger: viewDidLoadTrigger
        )
        let output = imageViewerViewModel.transform(input)
        
        output.resultList
            .drive(imageViewerView.collectionView.rx.items(
                cellIdentifier: ImageViewerCollectionViewCell.identifier,
                cellType: ImageViewerCollectionViewCell.self)) { index, item, cell in
                    cell.configureData(item)
                }
                .disposed(by: disposeBag)
        
    }

}

// MARK: - (옵션) Kingfisher Prefetch
//
//extension ImageViewerViewController: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        let urls = indexPaths.compactMap { index in
//            imageViewerViewModel.resultList.value[safe: index.item]?.imageURL
//        }
//        ImagePrefetcher(urls: urls).start()
//    }
//}
