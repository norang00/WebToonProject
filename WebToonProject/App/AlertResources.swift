//
//  AlertResources.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/24/25.
//

import Foundation

protocol AlertConvertible {
    var title: String { get }
    var message: String { get }
}

enum AlertType: String {
    case screenShot
    case cellularWarning
}

enum CustomError: String, Error {
    case askAdmin
    case serverIssue
    case noInternet
}

extension AlertType: AlertConvertible {
    var title: String {
        NSLocalizedString("\(rawValue)Title", comment: "")
    }
    var message: String {
        NSLocalizedString("\(rawValue)Message", comment: "")
    }
}

extension CustomError: AlertConvertible {
    var title: String {
        NSLocalizedString("\(rawValue)Title", comment: "")
    }
    var message: String {
        NSLocalizedString("\(rawValue)Message", comment: "")
    }
}
