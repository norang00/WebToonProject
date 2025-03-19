//
//  WebToon.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let webtoons: [Webtoon]
    let total: Int
    let isLastPage: Bool
}

// MARK: - Webtoon
struct Webtoon: Codable {
    let id, title: String
    let provider: Provider
    let updateDays: [String]
    let url: String
    let thumbnail: [String]
    let isEnd, isFree, isUpdated: Bool
    let ageGrade: Int
    let freeWaitHour: Int?
    let authors: [String]
}

enum Provider: String, Codable {
    case naver = "NAVER"
}
