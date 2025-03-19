//
//  UIFont+Extension.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit

extension UIFont {
    static func customFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let fontName = "YourCustomFontName"  // 프로젝트에 추가한 커스텀 폰트 이름으로 변경
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    // 미리 정의해둔 스타일 예시
    static var titleFont: UIFont {
        return UIFont.customFont(ofSize: 20, weight: .bold)
    }
    
    static var bodyFont: UIFont {
        return UIFont.customFont(ofSize: 16)
    }
    
    static var captionFont: UIFont {
        return UIFont.customFont(ofSize: 12)
    }
}
