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
    
    enum CustomImage: String {
        case basic = "basicImage"
        case isEnd = "isEnd"
        case isFree = "isFree"
        case isUpdated = "isUpdated"
    }
    
    // Keys for localization
    enum Keys: String {
        case recommend = "recommend"
        case search = "search"
        case like = "like"
        
        case dailyWebtoon = "dailyWebtoon"
        case updated = "updated"
    }
}
