//
//  Collection+Extension.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/23/25.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
