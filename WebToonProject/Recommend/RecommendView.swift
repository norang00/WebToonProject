//
//  RecommendView.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit
import SnapKit

final class RecommendView: BaseView {
    
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
            make.height.greaterThanOrEqualTo(400)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        dailyButton.setTitle("요일별 웹툰", for: .normal)
        dailyButton.backgroundColor = .accent
        
        collectionView.isScrollEnabled = false
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()

        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing = layout.minimumInteritemSpacing * 4
        let itemWidth = (screenWidth - totalSpacing) / 3
        let itemHeight = itemWidth * 1.8
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        return layout
    }
    
}
