//
//  TabButton.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/21/25.
//

import UIKit

final class TabButton: UIButton {
    
    private var border: CALayer?
    
    init(title: String, frame: CGRect) {
        super.init(frame: frame)
        setTitle(title, for: .normal)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        isSelected = false
        isUserInteractionEnabled = true
        
        backgroundColor = .white
        
        setTitleColor(.black, for: .selected)
        setTitleColor(.textGray, for: .normal)
        
        titleLabel?.font = .pretendardRegular(ofSize: 16)
        titleLabel?.textAlignment = .center
        
        updateBorder()
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel?.font = .pretendardBold(ofSize: 16)
            updateBorder(isSelected)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder(isSelected)
    }
    
    private func updateBorder(_ isSelected: Bool = false) {
        border?.removeFromSuperlayer()
        
        let bottomBorder = CALayer()
        let width: CGFloat = self.frame.size.width
        let height: CGFloat = isSelected ? 5.0 : 2.0
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - height,
                                    width: width, height: height)
        bottomBorder.backgroundColor = isSelected ? UIColor.black.cgColor : UIColor.textGray.cgColor
        
        self.layer.addSublayer(bottomBorder)
        self.border = bottomBorder

    }
}
