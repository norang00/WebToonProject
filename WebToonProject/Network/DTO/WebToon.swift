//
//  WebToon.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import Foundation

// MARK: - WebToonData
struct WebToonData: Decodable {
    let webtoons: [Webtoon]
    let total: Int
    let isLastPage: Bool
}

// MARK: - Webtoon
struct Webtoon: Decodable {
    let id, title: String
    let provider: String
    let updateDays: [String]
    let url: String
    let thumbnail: [String]
    let isEnd, isFree, isUpdated: Bool
    let ageGrade: Int
    let freeWaitHour: Int?
    let authors: [String]
}
