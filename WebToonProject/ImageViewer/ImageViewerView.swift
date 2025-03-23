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
    let nextButton = UIButton()
    let previousButton = UIButton()
    
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
        bottomBarView.addSubview(previousButton)
        bottomBarView.addSubview(nextButton)
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
            make.height.equalTo(50)
        }
        
        previousButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-40)
        }
        
        viewerToggleButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(likeButton.snp.trailing).offset(10)
        }
    }
    
    // MARK: - Styling
    override func configureView() {
        print(#function)
        
        backgroundColor = .black
        topBarView.backgroundColor = .black
        bottomBarView.backgroundColor = .black
        
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        
        titleLabel.text = "제목"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        
        previousButton.setTitle("◀︎", for: .normal)
        nextButton.setTitle("▶︎", for: .normal)
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        viewerToggleButton.setImage(Resources.SystemImage.upDownArrow.image, for: .normal)
        
        [previousButton, nextButton, likeButton, viewerToggleButton].forEach {
            $0.setTitleColor(.white, for: .normal)
            $0.tintColor = .white
        }
        
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            UINib(nibName: ImageViewerCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: ImageViewerCollectionViewCell.identifier
        )
    }
    
    func toggleScreen() {
        topBarView.isHidden.toggle()
        bottomBarView.isHidden.toggle()
    }
    
   
}
