//
//  Image.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/22/25.
//

import Foundation

// MARK: - ImageData
struct ImageData: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Image]
}

// MARK: - Image
struct Image: Codable {
    let title: String
    let link: String
    let sizeheight, sizewidth: String?
}
