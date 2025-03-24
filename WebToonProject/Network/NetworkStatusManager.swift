//
//  NetworkStatusManager.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/24/25.
//

import Network

import Foundation
import Network

final class NetworkStatusManager {
    static let shared = NetworkStatusManager()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private(set) var isUsingWiFi: Bool = false
    private(set) var isUsingCellular: Bool = false
    private(set) var isConnected: Bool = false

    private init() {
        // 초기 경로 상태
        let initialPath = monitor.currentPath
        self.isUsingWiFi = initialPath.usesInterfaceType(.wifi)
        self.isUsingCellular = initialPath.usesInterfaceType(.cellular)
        self.isConnected = initialPath.status == .satisfied

        monitor.pathUpdateHandler = { [weak self] path in
            self?.isUsingWiFi = path.usesInterfaceType(.wifi)
            self?.isUsingCellular = path.usesInterfaceType(.cellular)
            self?.isConnected = path.status == .satisfied

            print("[NetworkStatus] Connected: \(path.status == .satisfied), WiFi: \(path.usesInterfaceType(.wifi)), Cellular: \(path.usesInterfaceType(.cellular))")
        }

        monitor.start(queue: queue)
    }
}
