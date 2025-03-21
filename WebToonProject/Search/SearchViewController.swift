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
        let reachedBottomTrigger = searchView.tableView.rx.prefetchRows
            .map { $0.map { $0.row }.max() ?? 0 }
            .distinctUntilChanged()
            .withLatestFrom(searchViewModel.resultList.asObservable()) { index, items in (index, items.count)
            }
            .filter { index, count in
                return index >= count - 2
            }
            .map { _ in }
        
        let input = SearchViewModel.Input(
            searchClicked: searchView.searchBar.rx.searchButtonClicked,
            searchText: searchView.searchBar.rx.text.orEmpty,
            reachedBottom: reachedBottomTrigger
        )
        let output = searchViewModel.transform(input)
        
        searchViewModel.isLoading
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isLoading in
                if isLoading {
                    owner.searchView.loadingIndicator.startAnimating()
                } else {
                    owner.searchView.loadingIndicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)

        output.resultList
            .debug("resultList")
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
