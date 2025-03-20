//
//  Resources.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import Foundation

enum Resources {
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
        //general title
        case recommend = "recommend"
        case search = "search"
        case like = "like"
        
        //button title
        case dailyWebtoon = "dailyWebtoon"
        
        //section title
        case updated = "updated"
        case searchByFilter = "searchByFilter"
        case searchByAuthor = "searchByAuthor"

        //searchBar placeholder
        case placeholder = "placeholder"
        
        case searchIsFree = "searchIsFree"
        case searchIsUpdated = "searchIsUpdated"
    }
}
