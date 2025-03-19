//
//  Resources.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import Foundation

enum Resources {
    enum Font: String {
        case bold = "Pretendard-Bold"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
    }
    
    enum SystemImage: String {
        case back = "arrow.left"
        case search = "magnifyingglass"
        case recommend = "star"
        case like = "heart.fill"
        case unlike = "heart"
        case chevronRight = "chevron.right"
    }
    
    enum Keys {
        enum TabTitle: String {
            case tab_0 = "tab_0"
            case tab_1 = "tab_1"
            case tab_2 = "tab_2"
        }
    }
}
