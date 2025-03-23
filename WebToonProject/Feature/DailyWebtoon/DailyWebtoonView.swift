//
//  DailyWebtoonView.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/21/25.
//

import UIKit
import SnapKit

final class DailyWebtoonView: BaseView {
    
    // MARK: - UI Components
    private(set) var weekdayButtons: [(day: Resources.WeekDay, button: TabButton)] = []
    private let stackView = UIStackView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let verticalInset: CGFloat = 12
        let horizontalInset: CGFloat = 12
        let horizontalSpacing: CGFloat = horizontalInset*2
        let itemSpacing: CGFloat = layout.minimumInteritemSpacing * 2
        let itemWidth: CGFloat = (screenWidth - itemSpacing - horizontalSpacing) / 3
        let itemHeight: CGFloat = itemWidth * 1.8
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = .init(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 4
        return layout
    }
    
    // MARK: - Hierarchy
    override func configureHierarchy() {
        addSubview(stackView)
        addSubview(collectionView)
        
        Resources.WeekDay.allCases.forEach { day in
            let button = TabButton(title: day.localized, frame: .zero)
            weekdayButtons.append((day, button))
            stackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Layout
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Styling
    override func configureView() {
        super.configureView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(
            UINib(nibName: BasicCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: BasicCollectionViewCell.identifier
        )
    }
}

// MARK: - Functions
extension DailyWebtoonView {
    
    func selectButton(for day: Resources.WeekDay) {
        weekdayButtons.forEach { item in
            item.button.isSelected = (item.day == day)
        }
//        collectionView.setContentOffset(
//            CGPoint(x: 0, y: -collectionView.contentInset.top),
//            animated: true
//        )
    }
}
