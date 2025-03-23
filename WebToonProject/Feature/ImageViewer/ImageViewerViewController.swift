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
        imageViewerViewModel.imageKeyword = self.imageKeyword
        imageViewerView.collectionView.delegate = self
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
        
        imageViewerView.backButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        imageViewerView.shareButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.shareCurrentImage()
            }
            .disposed(by: disposeBag)
        
        imageViewerView.viewerToggleButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.toggleScrollDirection()
            }
            .disposed(by: disposeBag)
        
        imageViewerView.rx.tapGesture()
            .bind(with: self) { owner, _ in
                owner.toggleScreen()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Share Image
extension ImageViewerViewController {
    
    private func shareCurrentImage() {
        let visibleRect = CGRect(origin: imageViewerView.collectionView.contentOffset,
                                 size: imageViewerView.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = imageViewerView.collectionView.indexPathForItem(at: visiblePoint),
              let cell = imageViewerView.collectionView.cellForItem(at: indexPath) as? ImageViewerCollectionViewCell,
              let image = cell.cutImageView.image else {
            print("image not found")
            return
        }

        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view // iPad 대응

        self.present(activityVC, animated: true)
    }
}

// MARK: - Layout Toggle
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
    
    func toggleScreen() {
        imageViewerView.topBarView.isHidden.toggle()
        imageViewerView.bottomBarView.isHidden.toggle()
    }

    func toggleScrollDirection() {
        scrollDirection = (scrollDirection == .horizontal) ? .vertical : .horizontal
        imageViewerView.viewerToggleButton.setImage((scrollDirection == .horizontal) ?
                                                    Resources.SystemImage.upDownArrow.image :
                                                    Resources.SystemImage.leftRightArrow.image,
                                                    for: .normal)

        let currentIndex = imageViewerView.collectionView.indexPathsForVisibleItems.first?.item ?? 0
        guard let layout = imageViewerView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.invalidateLayout()
        layout.scrollDirection = (scrollDirection == .horizontal) ? .horizontal : .vertical
        imageViewerView.collectionView.isPagingEnabled = (scrollDirection == .horizontal)
        imageViewerView.collectionView.setCollectionViewLayout(layout, animated: false)
        
        let targetIndex = IndexPath(item: currentIndex, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.imageViewerView.collectionView.scrollToItem(at: targetIndex, at: .top, animated: false)
        }
        
        imageViewerView.collectionView.delegate = self
    }
}
