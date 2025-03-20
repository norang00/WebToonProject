//
//  SearchView.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/20/25.
//

import UIKit

final class SearchView: BaseView {

    let searchBar = UISearchBar()
    let searchBarBackgroundView = UIView()

    let searchByFilterHeader = SectionHeaderView()
    let searchByFilterStackView = UIStackView()
    let filterBadges: [SearchBadgeButton] = []
    
    let searchByAuthorHeader = SectionHeaderView()
    let searchByAuthorStackView = UIStackView()
    let authorBadges: [SearchBadgeButton] = []
    
    override func configureHierarchy() {
        addSubview(searchBarBackgroundView)
        searchBarBackgroundView.addSubview(searchBar)
        
        addSubview(searchByFilterHeader)
        addSubview(searchByFilterStackView)
        
        addSubview(searchByAuthorHeader)
        addSubview(searchByAuthorStackView)
    }
    
    override func configureLayout() {
        searchBarBackgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        searchBar.snp.makeConstraints { make in
            make.verticalEdges.equalTo(searchBarBackgroundView).inset(4)
            make.horizontalEdges.equalTo(searchBarBackgroundView).inset(4)
        }
        
        searchByFilterHeader.snp.makeConstraints { make in
            make.top.equalTo(searchBarBackgroundView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        searchByFilterStackView.snp.makeConstraints { make in
            make.top.equalTo(searchByFilterHeader.snp.bottom).offset(8)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
            make.width.greaterThanOrEqualTo(50)
            make.height.equalTo(32)
        }
        makeFilterBadges()
        
        searchByAuthorHeader.snp.makeConstraints { make in
            make.top.equalTo(searchByFilterStackView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        searchByAuthorStackView.snp.makeConstraints { make in
            make.top.equalTo(searchByAuthorHeader.snp.bottom).offset(8)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
            make.width.greaterThanOrEqualTo(50)
            make.height.equalTo(32)
        }
        makeAuthorBadges()

    }
    
    override func configureView() {
        super.configureView()

        searchBarBackgroundView.backgroundColor = .bgGray
        searchBarBackgroundView.layer.cornerRadius = 4

        searchBar.tintColor = .black
        searchBar.placeholder = Resources.Keys.placeholder.rawValue.localized
        searchBar.isTranslucent = true
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.font = .bodyFont
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)

        searchByFilterHeader.titleLabel.text = Resources.Keys.searchByFilter.rawValue.localized

        searchByFilterStackView.axis = .horizontal
        searchByFilterStackView.spacing = 8
        
        searchByAuthorHeader.titleLabel.text = Resources.Keys.searchByAuthor.rawValue.localized
 
        searchByAuthorStackView.axis = .horizontal
        searchByAuthorStackView.spacing = 8
    }
    
    private func makeFilterBadges() {
        let filterList = [
            Resources.Keys.searchIsFree.rawValue.localized,
            Resources.Keys.searchIsUpdated.rawValue.localized
        ]
        for filter in filterList {
            let button = SearchBadgeButton()
            button.setTitle(filter, for: .normal)
            searchByFilterStackView.addArrangedSubview(button)
        }
    }

    private func makeAuthorBadges() {
        let authorList = [
            "자까", "순끼", "이말년", "조석", "박태준", "모죠"
        ]
        for author in authorList {
            let button = SearchBadgeButton()
            button.setTitle(author, for: .normal)
            searchByAuthorStackView.addArrangedSubview(button)
        }
    }
}
