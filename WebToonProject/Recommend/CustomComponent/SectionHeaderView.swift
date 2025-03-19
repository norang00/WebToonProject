//
//  SectionHeaderView.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit
import SnapKit

final class SectionHeaderView: BaseView {

    private let titleLabel = UILabel()
    private let button = UIButton()
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(button)
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(8)
        }
        button.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(8)
        }
    }

    override func configureView() {
        super.configureView()
        
        titleLabel.text = "인기 급상승 중"
        titleLabel.font = UIFont(name: Resources.Font.bold.rawValue, size: 16)
        
        button.setImage(UIImage(systemName: Resources.SystemImage.chevronRight.rawValue), for: .normal)
        button.tintColor = .black
    }
}
