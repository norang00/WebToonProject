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
    private let sectionHeaderView = SectionHeaderView()
    private let dailyButton = UIButton()
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
            make.height.equalTo(280)
        }
        
        dailyButton.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        sectionHeaderView.snp.makeConstraints { make in
            make.top.equalTo(dailyButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sectionHeaderView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(400)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        dailyButton.setTitle("요일별 웹툰", for: .normal)
        dailyButton.backgroundColor = .accent
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        return layout
    }
    
}
