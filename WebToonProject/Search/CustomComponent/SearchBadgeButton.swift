//
//  SearchBadgeButton.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/20/25.
//

import UIKit

final class SearchBadgeButton: UIButton {

    private var padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    private func configureButton() {
        titleLabel?.font = .bodyFont
        setTitleColor(.black, for: .normal)
        contentHorizontalAlignment = .center

        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 16
        backgroundColor = .white
    }
}
