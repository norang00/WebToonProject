//
//  DailyWebtoonViewController.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/21/25.
//

import UIKit
import RxSwift
import RxCocoa

final class DailyWebtoonViewController: BaseViewController {
    
    private let dailyWebtoonView = DailyWebtoonView()
    private let dailyWebtoonViewModel = DailyWebtoonViewModel()
    
    private let viewDidLoadTrigger = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    override func loadView() {
        view = dailyWebtoonView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Resources.Keys.daily.localized
        
        bind()
        viewDidLoadTrigger.accept(())
        if let today = Resources.WeekDay.today {
            dailyWebtoonView.selectButton(for: today) // 버튼 선택 상태 반영
        }
    }

    private func bind() {
        let dayButtonTapped = Observable.merge(
            dailyWebtoonView.weekdayButtons.map { pair in
                pair.button.rx.tap
                    .map { pair.day }
                    .do(onNext: { [weak self] day in
                        self?.dailyWebtoonView.selectButton(for: day)
                    })
            }
        )
        
        let reachedBottomTrigger = dailyWebtoonView.collectionView.rx.prefetchItems
            .map { $0.map { $0.row }.max() ?? 0 }
            .distinctUntilChanged()
            .withLatestFrom(dailyWebtoonViewModel.resultList.asObservable()) { index, items in (index, items.count)
            }
            .filter { index, count in
                return index >= count - 2
            }
            .map { _ in }
        
        let input = DailyWebtoonViewModel.Input(
            viewDidLoadTrigger: viewDidLoadTrigger,
            dayButtonTapped: dayButtonTapped,
            reachedBottom: reachedBottomTrigger
        )
        let output = dailyWebtoonViewModel.transform(input)
        
        output.resultList
            .drive(dailyWebtoonView.collectionView.rx.items(
                cellIdentifier: BasicCollectionViewCell.identifier,
                cellType: BasicCollectionViewCell.self)) { index, item, cell in
                    if item.title == "__shimmer__" {
                        cell.showShimmer()
                    } else {
                        cell.hideShimmer()
                        cell.configureData(item)
                    }
                }
                .disposed(by: disposeBag)
        
        dailyWebtoonView.collectionView.rx.modelSelected(Webtoon.self)
            .bind(with: self) { owner, item in
                let nextVC = ImageViewerViewController()
                nextVC.webtoon = item
                print("recommendView.collectionView.rx.modelSelected", item.title)
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
    }

}
