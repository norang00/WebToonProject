//
//  SearchView.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/20/25.
//

import UIKit

final class SearchView: BaseView {
    
    // MARK: - UI Components
    let searchBar = UISearchBar()
    let searchBarBackgroundView = UIView()
    
    let searchByFilterHeader = SectionHeaderView()
    let searchByFilterStackView = UIStackView()
    var filterButtons: [SearchBadgeButton] = []
    
    let searchByAuthorHeader = SectionHeaderView()
    let searchByAuthorStackView = UIStackView()
    var authorButtons: [SearchBadgeButton] = []
    
    let tableView = UITableView()
    let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Hierarchy
    override func configureHierarchy() {
        addSubview(searchBarBackgroundView)
        searchBarBackgroundView.addSubview(searchBar)
        
        addSubview(searchByFilterHeader)
        addSubview(searchByFilterStackView)
        
        addSubview(searchByAuthorHeader)
        addSubview(searchByAuthorStackView)
        
        addSubview(tableView)
    }
    
    // MARK: - Layout
    override func configureLayout() {
        searchBarBackgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        searchBar.snp.makeConstraints { make in
            make.verticalEdges.equalTo(searchBarBackgroundView).inset(4)
            make.horizontalEdges.equalTo(searchBarBackgroundView).inset(4)
        }
        
        searchByFilterHeader.snp.makeConstraints { make in
            make.top.equalTo(searchBarBackgroundView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(40)
        }
        
        searchByFilterStackView.snp.makeConstraints { make in
            make.top.equalTo(searchByFilterHeader.snp.bottom)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
            make.width.greaterThanOrEqualTo(50)
            make.height.equalTo(32)
        }
        makeFilterButtons()
        
        searchByAuthorHeader.snp.makeConstraints { make in
            make.top.equalTo(searchByFilterStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(40)
        }
        
        searchByAuthorStackView.snp.makeConstraints { make in
            make.top.equalTo(searchByAuthorHeader.snp.bottom)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
            make.width.greaterThanOrEqualTo(50)
            make.height.equalTo(32)
        }
        makeAuthorButtons()
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBarBackgroundView.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Styling
    override func configureView() {
        super.configureView()
        
        searchBarBackgroundView.backgroundColor = .bgGray
        searchBarBackgroundView.layer.cornerRadius = 4
        
        searchBar.tintColor = .black
        searchBar.placeholder = Resources.Keys.placeholder.localized
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.font = .pretendardBold(ofSize: 16)
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        searchByFilterHeader.titleLabel.text = Resources.Keys.searchByFilter.localized
        
        searchByFilterStackView.axis = .horizontal
        searchByFilterStackView.spacing = 8
        
        searchByAuthorHeader.titleLabel.text = Resources.Keys.searchByAuthor.localized
        
        searchByAuthorStackView.axis = .horizontal
        searchByAuthorStackView.spacing = 8
        
        tableView.isHidden = true
        tableView.rowHeight = 140
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UINib(nibName: BasicTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: BasicTableViewCell.identifier)
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .lightGray
        tableView.tableFooterView = loadingIndicator
    }
}

// MARK: - Functions
extension SearchView {
    
    private func makeFilterButtons() {
        let filterList = [
            Resources.Keys.searchIsFree.localized,
            Resources.Keys.searchIsUpdated.localized
        ]
        for filter in filterList {
            let button = SearchBadgeButton()
            button.setTitle(filter, for: .normal)
            searchByFilterStackView.addArrangedSubview(button)
            filterButtons.append(button)
        }
    }

    private func makeAuthorButtons() {
        let authorList = [
            "자까", "순끼", "이말년", "조석", "박태준", "모죠" // 외부에서 데이터 받아오는 것을 가정
        ]
        for author in authorList {
            let button = SearchBadgeButton()
            button.setTitle(author, for: .normal)
            searchByAuthorStackView.addArrangedSubview(button)
            authorButtons.append(button)
        }
    }
}
