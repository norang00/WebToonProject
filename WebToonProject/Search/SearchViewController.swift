//
//  SearchViewController.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController {
    
    private let searchView = SearchView()
    private let searchViewModel = SearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Resources.Keys.search.rawValue.localized

        bind()
    }
    
    private func bind() {
        let input = SearchViewModel.Input(
            searchClicked: searchView.searchBar.rx.searchButtonClicked,
            searchText: searchView.searchBar.rx.text.orEmpty
        )
        let output = searchViewModel.transform(input)
        
        output.resultList
            .do(onNext: { [weak self] _ in
                self?.searchView.tableView.isHidden = false
            })
            .drive(searchView.tableView.rx.items(cellIdentifier: BasicTableViewCell.identifier, cellType: BasicTableViewCell.self)) { index, item, cell in
                print("resultList", index, item.title)
                cell.configureData(item)
            }
            .disposed(by: disposeBag)
    }

}
