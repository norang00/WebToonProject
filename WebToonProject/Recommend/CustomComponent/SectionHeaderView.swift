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
        
        titleLabel.text = Resources.Keys.updated.rawValue.localized
        titleLabel.font = .pretendardBold(ofSize: 20)
        
        button.isHidden = true
        button.setImage(UIImage(systemName: Resources.SystemImage.chevronRight.rawValue), for: .normal)
        button.tintColor = .black
    }
}
