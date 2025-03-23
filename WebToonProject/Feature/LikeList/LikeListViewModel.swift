//
//  LikeListViewModel.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/23/25.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class LikeListViewModel: BaseViewModel<LikedWebtoon, LikeListViewModel.Input, LikeListViewModel.Output> {

    private let realm = try! Realm()
    
    enum SortType {
        case title, regDate
    }

    struct Input {
        let viewWillAppear: Observable<Void>
        let sortButtonTapped: Observable<Void>
    }

    struct Output {
        let resultList: Driver<[LikedWebtoon]>
        let countText: Driver<String>
        let sortTitle: Driver<String>
    }

    private var currentSort: SortType = .regDate

    override func transform(_ input: Input) -> Output {
        let resultRelay = BehaviorRelay<[LikedWebtoon]>(value: [])

        let sortTitleRelay = BehaviorRelay<String>(value: currentSort == .title ? "제목순" : "등록순")

        input.viewWillAppear
            .subscribe(with: self) { owner, _ in owner.fetchSorted() }
            .disposed(by: disposeBag)

        input.sortButtonTapped
            .subscribe(with: self) { owner, _ in
                owner.toggleSort()
                sortTitleRelay.accept(owner.currentSortTitle())
                owner.fetchSorted()
            }
            .disposed(by: disposeBag)

        resultList
            .bind(to: resultRelay)
            .disposed(by: disposeBag)

        let countText = resultRelay
            .map { "\($0.count) " + Resources.Keys.howMany.localized }
            .asDriver(onErrorJustReturn: "")

        return Output(
            resultList: resultRelay.asDriver(onErrorJustReturn: []),
            countText: countText,
            sortTitle: sortTitleRelay.asDriver(onErrorJustReturn: "")
        )
    }

    private func toggleSort() {
        currentSort = (currentSort == .title) ? .regDate : .title
    }

    private func currentSortTitle() -> String {
        currentSort == .title ? "제목순" : "등록순"
    }

    private func fetchSorted() {
        let results = realm.objects(LikedWebtoon.self)
        let sorted = currentSort == .title
            ? results.sorted(byKeyPath: "title")
            : results.sorted(byKeyPath: "regDate", ascending: false)

        resultToShow = Array(sorted)
        resultList.accept(resultToShow)
    }
}
