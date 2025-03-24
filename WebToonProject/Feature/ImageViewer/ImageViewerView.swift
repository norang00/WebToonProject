//
//  ImageViewerView.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/22/25.
//

import UIKit
import SnapKit
import RxSwift

final class ImageViewerView: BaseView {

    // MARK: - UI Components
    let topBarView = UIView()
    let backButton = UIButton()
    let titleLabel = UILabel()
    let shareButton = UIButton()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    let bottomBarView = UIView()
    let likeButton = UIButton()
    let viewerToggleButton = UIButton()
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    // MARK: - Hierarchy
    override func configureHierarchy() {
        addSubview(collectionView)
        addSubview(topBarView)
        addSubview(bottomBarView)
        
        topBarView.addSubview(backButton)
        topBarView.addSubview(titleLabel)
        topBarView.addSubview(shareButton)
        
        bottomBarView.addSubview(likeButton)
        bottomBarView.addSubview(viewerToggleButton)
    }
    
    // MARK: - Layout
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topBarView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
        
        shareButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
        
        bottomBarView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        likeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        viewerToggleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Styling
    override func configureView() {
        backgroundColor = .black
        
        topBarView.backgroundColor = .black
        
        backButton.setImage(Resources.SystemImage.chevronLeft.image, for: .normal)
        titleLabel.font = .pretendardBold(ofSize: 16)
        titleLabel.textColor = .white
        shareButton.setImage(Resources.SystemImage.share.image, for: .normal)
                
        collectionView.backgroundColor = .black

        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            UINib(nibName: ImageViewerCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: ImageViewerCollectionViewCell.identifier
        )
        
        bottomBarView.backgroundColor = .black
        
        [likeButton, viewerToggleButton].forEach {
            $0.setTitleColor(.white, for: .normal)
            $0.tintColor = .white
        }
        likeButton.setImage(Resources.SystemImage.unlike.image, for: .normal)
        viewerToggleButton.setImage(Resources.SystemImage.upDownArrow.image, for: .normal)
    }
}
