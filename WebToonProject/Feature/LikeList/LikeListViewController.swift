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
    private let disposeBag = DisposeBag()

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
        likeListView.sortButton.rx.tap
            .bind(to: sortButtonTapped)
            .disposed(by: disposeBag)

        let input = LikeListViewModel.Input(
            viewWillAppear: viewWillAppearTrigger.asObservable(),
            sortButtonTapped: sortButtonTapped.asObservable()
        )
        let output = viewModel.transform(input)

        output.resultList
            .drive(likeListView.tableView.rx.items(
                cellIdentifier: BasicTableViewCell.identifier,
                cellType: BasicTableViewCell.self
            )) { _, item, cell in
                let webtoon = Webtoon(
                    id: item.id,
                    title: item.title,
                    provider: "",
                    updateDays: [],
                    url: item.url,
                    thumbnail: [item.thumbnail],
                    isEnd: item.isEnd,
                    isFree: false,
                    isUpdated: false,
                    ageGrade: 0,
                    freeWaitHour: 0,
                    authors: item.authors.components(separatedBy: ", ")
                )
                cell.configureData(webtoon)
                cell.starImageViews.forEach { $0.isHidden = true }
                cell.ratingLabel.isHidden = true
            }
            .disposed(by: disposeBag)

        output.countText
            .drive(likeListView.countLabel.rx.text)
            .disposed(by: disposeBag)

        output.sortTitle
            .drive(likeListView.sortButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
}
//
//final class LikeListViewController: BaseViewController {
//    
//    private let likeListView = LikeListView()
//    private let likeListViewModel = LikeListViewModel()
//    
//    private let disposeBag = DisposeBag()
//    
//    override func loadView() {
//        view = likeListView
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationItem.title = Resources.Keys.like.localized
//        
//        bind()
//        likeListViewModel.fetch()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        likeListViewModel.fetch()
//    }
//    
//    private func bind() {
//        // 정렬 버튼 탭
//        likeListView.sortButton.rx.tap
//            .bind(with: self) { owner, _ in
//                owner.likeListViewModel.toggleSort()
//                owner.likeListView.sortButton.setTitle(owner.likeListViewModel.currentSortTitle(), for: .normal)
//            }
//            .disposed(by: disposeBag)
//        
//        likeListViewModel.resultList
//            .asDriver(onErrorJustReturn: [])
//            .drive(likeListView.tableView.rx.items(
//                cellIdentifier: BasicTableViewCell.identifier,
//                cellType: BasicTableViewCell.self)
//            ) { index, item, cell in
//                let webtoon = Webtoon(
//                    id: item.id,
//                    title: item.title,
//                    provider: "",
//                    updateDays: [],
//                    url: item.url,
//                    thumbnail: [item.thumbnail],
//                    isEnd: item.isEnd,
//                    isFree: false,
//                    isUpdated: false,
//                    ageGrade: 0,
//                    freeWaitHour: 0,
//                    authors: item.authors.components(separatedBy: ", ")
//                )
//                cell.configureData(webtoon)
//                cell.starImageViews.forEach { $0.isHidden = true }
//                cell.ratingLabel.isHidden = true
//            }
//            .disposed(by: disposeBag)
//        
//        likeListViewModel.resultList
//            .map { "\($0.count) " + Resources.Keys.howMany.localized }
//            .bind(to: likeListView.countLabel.rx.text)
//            .disposed(by: disposeBag)
//    }
//}
