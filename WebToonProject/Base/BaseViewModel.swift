//
//  BaseViewModel.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel<T, I, O> {
    typealias Input = I
    typealias Output = O
    
    // default value for pagination
    var currentPage = 1
    var hasNextPage = true
    var resultToShow: [T] = []
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let resultList = PublishRelay<[T]>()
    let errorMessage = PublishRelay<CustomError>()

    let disposeBag = DisposeBag()

    func transform(_ input: Input) -> Output {
        fatalError("Subclasses must override transform(input:)")
    }
    
    func resetPagination() {
        currentPage = 1
        hasNextPage = true
        resultToShow = []
    }
}
