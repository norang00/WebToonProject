//
//  LikeListViewController.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

final class LikeListViewController: BaseViewController {

    private let likeListView = LikeListView()
    private let viewModel = LikeListViewModel()

    private let viewWillAppearTrigger = PublishRelay<Void>()
    private let sortButtonTapped = PublishRelay<Void>()

    override func loadView() {
        view = likeListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Resources.Keys.like.localized
        
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppearTrigger.accept(())
    }

    private func bind() {
        let input = LikeListViewModel.Input(
            viewWillAppear: viewWillAppearTrigger.asObservable(),
            sortButtonTapped: sortButtonTapped.asObservable()
        )
        let output = viewModel.transform(input)

        output.countText
            .drive(likeListView.countLabel.rx.text)
            .disposed(by: disposeBag)

        output.sortTitle
            .drive(likeListView.sortButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        output.resultList
            .drive(likeListView.tableView.rx.items(
                cellIdentifier: BasicTableViewCell.identifier,
                cellType: BasicTableViewCell.self)) { index, item, cell in
                    cell.configureData(item)
                    cell.hideRatingInfo()
                }
            .disposed(by: disposeBag)

        likeListView.sortButton.rx.tap
            .bind(to: sortButtonTapped)
            .disposed(by: disposeBag)
        
        likeListView.tableView.rx.modelSelected(Webtoon.self)
            .bind(with: self) { owner, item in
                let nextVC = ImageViewerViewController()
                nextVC.webtoon = item
                owner.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        likeListView.tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                owner.likeListView.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
