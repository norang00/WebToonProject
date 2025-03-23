//
//  LikedWebtoon.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/23/25.
//

import Foundation
import RealmSwift

final class LikedWebtoon: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var url: String
    @Persisted var thumbnail: String
    @Persisted var isEnd: Bool
    @Persisted var isFree: Bool
    @Persisted var isUpdated: Bool
    @Persisted var authors: String
    @Persisted var regDate: Date
    @Persisted var isLiked: Bool

    var imageURL: URL? {
        return URL(string: thumbnail)
    }

    convenience init(id: String, title: String, url: String, thumbnail: String, isEnd: Bool, isFree: Bool, isUpdated: Bool, authors: String, regDate: Date, isLiked: Bool) {
        self.init()
        
        self.id = id
        self.title = title
        self.url = url
        self.thumbnail = thumbnail
        self.isEnd = isEnd
        self.isFree = isFree
        self.isUpdated = isUpdated
        self.authors = authors
        self.regDate = Date()
        self.isLiked = isLiked
    }
}
