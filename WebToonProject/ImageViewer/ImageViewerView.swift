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
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let bottomBarView = UIView()
    let likeButton = UIButton()
    let viewerToggleButton = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let screenWidth = UIScreen.main.bounds.width
        let totalHeight = bounds.height
        
        let topBarHeight: CGFloat = topBarView.frame.height
        let bottomBarHeight: CGFloat = bottomBarView.frame.height
        
        let itemHeight = totalHeight - topBarHeight - bottomBarHeight
        
        layout.itemSize = CGSize(width: screenWidth, height: itemHeight)
        layout.invalidateLayout()
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
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        topBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        shareButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        bottomBarView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
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
        titleLabel.text = "제목"
        titleLabel.font = .pretendardBold(ofSize: 16)
        titleLabel.textColor = .white
        shareButton.setImage(Resources.SystemImage.share.image, for: .normal)
                
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .black
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
