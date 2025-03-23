//
//  LikeListView.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/23/25.
//

import UIKit

final class LikeListView: BaseView {
    
    let countLabel = UILabel()
    let sortButton = UIButton(type: .system)
    let tableView = UITableView()
    
    override func configureHierarchy() {
        addSubview(countLabel)
        addSubview(sortButton)
        addSubview(tableView)
    }
    
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
    
    override func configureView() {
        super.configureView()
        
        countLabel.font = .pretendardBold(ofSize: 14)
        countLabel.textColor = .black
        countLabel.text = Resources.Keys.howMany.localized
        
        sortButton.setTitle(Resources.Keys.sortByReg.localized, for: .normal)
        sortButton.titleLabel?.font = .pretendardRegular(ofSize: 14)
        
        tableView.register(UINib(nibName: BasicTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: BasicTableViewCell.identifier)
        tableView.rowHeight = 140
    }
}
