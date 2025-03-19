//
//  String+Extension.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with: String) -> String {
        return String(format: self.localized, with)
    }
}
