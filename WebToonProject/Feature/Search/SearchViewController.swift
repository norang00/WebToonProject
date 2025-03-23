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
    
    private var selectedFilterButton: UIButton?
    private var selectedAuthorButton: UIButton?
    
    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Resources.Keys.search.localized
        bind()
    }
    
    private func bind() {
        let filterButtons = searchView.filterButtons
        let filterButtonTapped = Observable.from(filterButtons)
            .flatMap { button in
                button.rx.tap
                    .map { [weak self] in
                        self?.searchView.tableView.isHidden = false
                        let name = button.title(for: .normal) ?? ""
                        self?.searchView.searchBar.text = name
                        return name
                    }
                    .compactMap { FilterType(title: $0) }
            }
        
        let authorButtons = searchView.authorButtons
        let authorButtonTapped = Observable.merge(
            authorButtons.map { button in
                button.rx.tap
                    .map { [weak self] in
                        self?.searchView.tableView.isHidden = false
                        let name = button.title(for: .normal) ?? ""
                        self?.searchView.searchBar.text = name
                        return name
                    }
            }
        )
        
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
            filterButtonTapped: filterButtonTapped,
            authorButtonTapped: authorButtonTapped,
            reachedBottom: reachedBottomTrigger
        )
        let output = searchViewModel.transform(input)

        searchView.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, value in
                owner.searchView.tableView.isHidden = value.isEmpty
            }
            .disposed(by: disposeBag)
        
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
            .do(onNext: { [weak self] _ in
                self?.searchView.endEditing(true)
                self?.searchView.tableView.isHidden = false
            })
            .drive(searchView.tableView.rx.items(
                cellIdentifier: BasicTableViewCell.identifier,
                cellType: BasicTableViewCell.self
            )) { index, item, cell in
                if item.title == "__shimmer__" {
                    cell.showShimmer()
                } else {
                    cell.hideShimmer()
                    cell.configureData(item)
                }
            }
            .disposed(by: disposeBag)
        
        searchView.tableView.rx.modelSelected(Webtoon.self)
            .bind(with: self) { owner, item in
                let nextVC = ImageViewerViewController()
                nextVC.webtoon = item
                print("recommendView.collectionView.rx.modelSelected", item.title)
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
    }

}

enum FilterType {
    case isFree
    case isUpdated

    init?(title: String) {
        switch title {
        case Resources.Keys.searchIsFree.localized:
            self = .isFree
        case Resources.Keys.searchIsUpdated.localized:
            self = .isUpdated
        default:
            return nil
        }
    }
}
