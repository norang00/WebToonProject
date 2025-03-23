//
//  LikeListView.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/23/25.
//

import UIKit

final class LikeListView: BaseView {
    
    // MARK: - UI Components
    let countLabel = UILabel()
    let sortButton = UIButton(type: .system)
    let tableView = UITableView()
    
    // MARK: - Hierarchy
    override func configureHierarchy() {
        addSubview(countLabel)
        addSubview(sortButton)
        addSubview(tableView)
    }
    
    // MARK: - Layout
    override func configureLayout() {
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().inset(16)
        }
        
        sortButton.snp.makeConstraints { make in
            make.centerY.equalTo(countLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Styling
    override func configureView() {
        super.configureView()
        
        countLabel.font = .pretendardBold(ofSize: 14)
        countLabel.text = Resources.Keys.howMany.localized
        countLabel.textColor = .black
        
        sortButton.titleLabel?.font = .pretendardRegular(ofSize: 14)
        sortButton.setTitle(Resources.Keys.sortByReg.localized, for: .normal)
        
        tableView.rowHeight = 140
        tableView.register(
            UINib(nibName: BasicTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: BasicTableViewCell.identifier
        )
    }
}
