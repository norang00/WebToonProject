//
//  BaseView.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class BaseView: UIView {
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        configureKeyboardDismiss()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() {
        backgroundColor = .white
    }
    
    private func configureKeyboardDismiss() {
        self.rx.tapGesture() { recognizer, _ in
            recognizer.cancelsTouchesInView = false
        }
        .when(.recognized)
        .bind(with: self) { owner, _ in
            owner.endEditing(true)
        }
        .disposed(by: disposeBag)
    }
}
