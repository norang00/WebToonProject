//
//  Resources.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit

enum Resources {
    enum SystemImage: String {
        case back = "arrow.left"
        case search = "magnifyingglass"
        case recommend = "star"
        case like = "heart.fill"
        case unlike = "heart"
        case chevronRight = "chevron.right"
        case upDownArrow = "arrow.up.and.down.square"
        case leftRightArrow = "arrow.left.and.right.square"
        
        var image: UIImage? {
            UIImage(systemName: self.rawValue)
        }
    }
    
    enum CustomImage: String {
        case placeholder = "basicImage"
        case isEnd = "isEnd"
        case isFree = "isFree"
        case isUpdated = "isUpdated"
        case starGreen = "star_green"
        case starGray = "star_gray"
        
        var image: UIImage? {
            UIImage(named: self.rawValue)
        }
    }
    
    // Keys for localization
    enum Keys: String {
        //general title
        case recommend
        case search
        case like
        case daily
        
        //button title
        case dailyWebtoon
        
        //section title
        case updated
        case searchByFilter
        case searchByAuthor
        
        //searchBar placeholder
        case placeholder
        
        case searchIsFree
        case searchIsUpdated
        
        var localized: String {
            NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    enum WeekDay: String, CaseIterable {
        case mon, tue, wed, thu, fri, sat, sun
        
        var localized: String {
            NSLocalizedString(self.rawValue, comment: "")
        }
        
        var code: String {
            self.rawValue
        }
        
        static var today: Resources.WeekDay? {
            let calendar = Calendar.current
            let weekdayIndex = calendar.component(.weekday, from: Date())
            let weekdayMap: [Int: Resources.WeekDay] = [
                1: .sun,
                2: .mon,
                3: .tue,
                4: .wed,
                5: .thu,
                6: .fri,
                7: .sat
            ]
            return weekdayMap[weekdayIndex]
        }
    }
}
