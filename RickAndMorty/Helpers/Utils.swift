//
//  Utils.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation
import SystemConfiguration

protocol UtilsProtocol {
    var existsConnection: Bool { get }
}

final class Utils: UtilsProtocol {
    var existsConnection: Bool {
        Reachability.isConnectedToNetwork
    }
}

// MARK: - Network connection

private final class Reachability {

    /// Note: SCNetworkReachability is deprecated in iOS 17.4,
    /// kept here for deterministic sync checks (fast, non-blocking).
    /// In production, prefer NWPathMonitor for continuous monitoring.

    static var isConnectedToNetwork: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        return withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { addressPtr in
                guard let reachability = SCNetworkReachabilityCreateWithAddress(nil, addressPtr) else {
                    return false
                }
                var flags = SCNetworkReachabilityFlags()
                guard SCNetworkReachabilityGetFlags(reachability, &flags) else {
                    return false
                }
                // WiFi or Cellular and doesn't require connection
                let isReachable = flags.contains(.reachable)
                let needsConnection = flags.contains(.connectionRequired)
                return (isReachable && !needsConnection)
            }
        }
    }
}
