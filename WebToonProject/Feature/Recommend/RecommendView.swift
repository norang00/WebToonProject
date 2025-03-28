//
//  RecommendView.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit
import SnapKit

final class RecommendView: BaseView {
    
    private var collectionViewHeightConstraint: Constraint?

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let bannerView = BannerView()
    let dailyButton = UIButton()
    let sectionHeaderView = SectionHeaderView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let verticalInset: CGFloat = 4
        let horizontalInset: CGFloat = 12
        let horizontalSpacing: CGFloat = horizontalInset*2
        let itemSpacing: CGFloat = layout.minimumInteritemSpacing * 2
        let itemWidth: CGFloat = (screenWidth - itemSpacing - horizontalSpacing) / 3
        let itemHeight: CGFloat = itemWidth * 1.8
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = .init(top: verticalInset, left: horizontalInset,
                                    bottom: verticalInset, right: horizontalInset)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 4
        
        return layout
    }

    // MARK: - Hierarchy
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(bannerView)
        contentView.addSubview(dailyButton)
        contentView.addSubview(sectionHeaderView)
        contentView.addSubview(collectionView)
    }

    // MARK: - Layout
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalToSuperview()
        }
        
        bannerView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(160)
        }
        
        dailyButton.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        sectionHeaderView.snp.makeConstraints { make in
            make.top.equalTo(dailyButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sectionHeaderView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)
            collectionViewHeightConstraint = make.height.equalTo(0).constraint
        }
    }
    
    // MARK: - Styling
    override func configureView() {
        super.configureView()
        
        scrollView.showsVerticalScrollIndicator = false
        
        dailyButton.setTitle(Resources.Keys.dailyWebtoon.localized, for: .normal)
        dailyButton.titleLabel?.font = .pretendardBold(ofSize: 18)
        dailyButton.backgroundColor = .accent
        
        sectionHeaderView.titleLabel.text = Resources.Keys.updated.localized
        collectionView.register(UINib(nibName: BasicCollectionViewCell.identifier, bundle: nil),
                                              forCellWithReuseIdentifier: BasicCollectionViewCell.identifier)
        collectionView.isScrollEnabled = false
    }
    
    func updateCollectionViewHeight() {
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint?.update(offset: contentHeight)
    }
}
