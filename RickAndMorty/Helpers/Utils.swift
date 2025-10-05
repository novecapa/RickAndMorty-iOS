//
//  Utils.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation
import Network

protocol UtilsProtocol {
    var existsConnection: Bool { get }
}

final class Utils: UtilsProtocol {
    var existsConnection: Bool {
        Reachability.isConnectedToNetwork()
    }
}

// MARK: - Network connection

private final class Reachability {
    public static func isConnectedToNetwork() -> Bool {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "ReachabilityCheck")
        var connected = false
        let semaphore = DispatchSemaphore(value: 0)

        monitor.pathUpdateHandler = { path in
            connected = (path.status == .satisfied)
            semaphore.signal()
            monitor.cancel()
        }
        monitor.start(queue: queue)
        _ = semaphore.wait(timeout: .now() + 0.5)

        return connected
    }
}
