//
//  UIFont+Extension.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit

extension UIFont {
    static func pretendardRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func pretendardMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    static func pretendardBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static func pretendardJPRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PretendardJP-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func pretendardJPMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PretendardJP-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    static func pretendardJPBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "PretendardJP-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static var titleFont: UIFont {
        return UIFont.pretendardBold(ofSize: 20)
    }
    
    static var bodyFont: UIFont {
        return UIFont.pretendardRegular(ofSize: 16)
    }
    
    static var captionFont: UIFont {
        return UIFont.pretendardMedium(ofSize: 12)
    }
    
    static var jpTitleFont: UIFont {
        return UIFont.pretendardJPBold(ofSize: 20)
    }
    
    static var jpBodyFont: UIFont {
        return UIFont.pretendardJPRegular(ofSize: 16)
    }
    
    static var jpCaptionFont: UIFont {
        return UIFont.pretendardJPMedium(ofSize: 12)
    }
}
