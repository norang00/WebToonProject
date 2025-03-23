//
//  ImageViewerViewController.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/22/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class ImageViewerViewController: BaseViewController {
    
    enum ViewerScrollDirection {
        case horizontal
        case vertical
    }
    
    private var scrollDirection: ViewerScrollDirection = .horizontal // init
    
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
        imageViewerViewModel.imageKeyword = self.imageKeyword
        imageViewerView.titleLabel.text = imageKeyword
        imageViewerView.collectionView.delegate = self
        
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

//        imageViewerView.collectionView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
        
        imageViewerView.backButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        imageViewerView.viewerToggleButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.toggleScrollDirection()
            }
            .disposed(by: disposeBag)
        
        imageViewerView.rx.tapGesture()
            .bind(with: self) { owner, _ in
                owner.imageViewerView.toggleScreen()
            }
            .disposed(by: disposeBag)
    }
}

extension ImageViewerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        
        if scrollDirection == .horizontal {
            return CGSize(width: collectionView.bounds.width,
                          height: collectionView.bounds.height)

        } else { // scrollDirection == .vertical
            let image = imageViewerViewModel.resultToShow[safe: indexPath.item]
            let imageWidth = Double(image?.sizewidth ?? "1") ?? 1
            let imageHeight = Double(image?.sizeheight ?? "1") ?? 1
            
            let ratio = screenWidth / imageWidth
            let scaledHeight = imageHeight * ratio
            return CGSize(width: screenWidth, height: scaledHeight)
        }
    }
    
    func toggleScrollDirection() {
        print(#function)
        
        let currentIndex = imageViewerView.collectionView.indexPathsForVisibleItems.first?.item ?? 0
        
        scrollDirection = (scrollDirection == .horizontal) ? .vertical : .horizontal
        
        imageViewerView.viewerToggleButton.setImage((scrollDirection == .horizontal) ?
                                    Resources.SystemImage.upDownArrow.image :
                                    Resources.SystemImage.leftRightArrow.image,
                                    for: .normal)
        
        guard let layout = imageViewerView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        layout.scrollDirection = (scrollDirection == .horizontal) ? .horizontal : .vertical
        imageViewerView.collectionView.isPagingEnabled = (scrollDirection == .horizontal)
        
        layout.invalidateLayout()
        imageViewerView.collectionView.setCollectionViewLayout(layout, animated: false)
        
        let targetIndex = IndexPath(item: currentIndex, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.imageViewerView.collectionView.scrollToItem(at: targetIndex, at: .top, animated: false)
        }
        
        imageViewerView.collectionView.delegate = self

    }
}


extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
