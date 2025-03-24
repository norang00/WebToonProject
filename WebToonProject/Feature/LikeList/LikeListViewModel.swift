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

final class LikeListViewModel: BaseViewModel<LikedWebtoon,
                               LikeListViewModel.Input,
                               LikeListViewModel.Output> {

    enum SortType {
        case title, regDate
    }

    struct Input {
        let viewWillAppear: Observable<Void>
        let sortButtonTapped: Observable<Void>
    }

    struct Output {
        let resultList: Driver<[Webtoon]>
        let countText: Driver<String>
        let sortTitle: Driver<String>
    }

    // MARK: - Properties
    private let realm = try! Realm()
    private var currentSort: SortType = .regDate

    private let resultRelay = BehaviorRelay<[Webtoon]>(value: [])
    private let sortTitleRelay = BehaviorRelay<String>(value: "")

    private var currentSortTitle: String {
        currentSort == .title ? Resources.Keys.sortByTitle.localized : Resources.Keys.sortByReg.localized
    }

    // MARK: - Transform
    override func transform(_ input: Input) -> Output {

        input.viewWillAppear
            .bind(with: self) { owner, _ in
                owner.sortTitleRelay.accept(owner.currentSortTitle)
                owner.fetchSorted()
            }
            .disposed(by: disposeBag)

        input.sortButtonTapped
            .bind(with: self) { owner, _ in
                owner.toggleSort()
                owner.fetchSorted()
            }
            .disposed(by: disposeBag)

        let countText = resultRelay
            .map { "\($0.count) " + Resources.Keys.howMany.localized }
            
        return Output(
            resultList: resultRelay.asDriver(onErrorJustReturn: []),
            countText: countText.asDriver(onErrorJustReturn: ""),
            sortTitle: sortTitleRelay.asDriver(onErrorJustReturn: "")
        )
    }

    // MARK: - Helpers
    private func toggleSort() {
        currentSort = (currentSort == .title) ? .regDate : .title
        sortTitleRelay.accept(currentSortTitle)
    }

    private func fetchSorted() {
        let liked = realm.objects(LikedWebtoon.self)
        let sorted = (currentSort == .title)
            ? liked.sorted(byKeyPath: "title")
            : liked.sorted(byKeyPath: "regDate", ascending: false)

        let converted = sorted.map {
            Webtoon(
                id: $0.id,
                title: $0.title,
                provider: "NAVER",
                updateDays: [],
                url: $0.url,
                thumbnail: [$0.thumbnail],
                isEnd: $0.isEnd,
                isFree: $0.isFree,
                isUpdated: $0.isUpdated,
                ageGrade: 0,
                freeWaitHour: 0,
                authors: $0.authors.components(separatedBy: ", ")
            )
        }

        resultRelay.accept(Array(converted))
    }
}
