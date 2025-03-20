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

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let bannerView = BannerView()
    private let dailyButton = UIButton()
    private let sectionHeaderView = SectionHeaderView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(bannerView)
        contentView.addSubview(dailyButton)
        contentView.addSubview(sectionHeaderView)
        contentView.addSubview(collectionView)
    }
    
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
            make.height.equalTo(240)
        }
        
        dailyButton.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        sectionHeaderView.snp.makeConstraints { make in
            make.top.equalTo(dailyButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sectionHeaderView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            collectionViewHeightConstraint = make.height.equalTo(0).constraint

            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        scrollView.showsVerticalScrollIndicator = false
        
        dailyButton.setTitle("요일별 웹툰", for: .normal)
        dailyButton.backgroundColor = .accent
        
        collectionView.isScrollEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 컬렉션뷰 레이아웃 업데이트 후 콘텐츠 사이즈 계산
        collectionView.layoutIfNeeded()
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
                collectionViewHeightConstraint?.update(offset: contentHeight)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let verticalInset: CGFloat = 8
        let horizontalInset: CGFloat = 12
        let horizontalSpacing: CGFloat = horizontalInset*2
        let itemSpacing: CGFloat = layout.minimumInteritemSpacing * 2
        let itemWidth: CGFloat = (screenWidth - itemSpacing - horizontalSpacing) / 3
        let itemHeight: CGFloat = itemWidth * 1.8
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = .init(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        return layout
    }
}
