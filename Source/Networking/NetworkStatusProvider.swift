// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation
import SystemConfiguration

/// Provides information related to the current network status.
protocol NetworkStatusProvider {
    /// The current network status.
    var status: NetworkStatus { get }
    func startNotifier()
}

/// Core's concrete implementation of ``NetworkStatusProvider``.
final class ChartboostCoreNetworkStatusProvider: NetworkStatusProvider {
    private let networkReachability: SCNetworkReachability? = {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
        if defaultRouteReachability == nil {
            logger.error("Failed to create SCNetworkReachability handle. Network information will be unavailable for this session.")
        }
        return defaultRouteReachability
    }()

    private let queue = DispatchQueue(label: "com.chartboost.core.reachability")

    private var notifierIsRunning = false

    private let reachabilityCallback: SCNetworkReachabilityCallBack = { _, flags, info in
        guard let info else { return }
        let weakReachability = Unmanaged<WeakReachability>.fromOpaque(info).takeUnretainedValue()
        weakReachability.reachability?.flags = flags
    }

    private var flags: SCNetworkReachabilityFlags?

    init() {
        updateFlags()
    }

    var status: NetworkStatus {
       guard let flags else {
           return .notReachable
       }
       var status: NetworkStatus = .unknown
       if !flags.contains(.connectionRequired) {
           // If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
           status = .reachableViaWiFi
       }
       if flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic) {
           // ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
           if !flags.contains(.interventionRequired) {
               // ... and no [user] intervention is needed...
               status = .reachableViaWiFi
           }
       }
       if flags.contains(.isWWAN) {
           // ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
           status = .reachableViaWWAN
       }
       return status
    }

    func startNotifier() {
        guard !notifierIsRunning, let networkReachability else {
            return
        }

        logger.debug("Starting reachability notifier...")

        let weakReachability = WeakReachability(reachability: self)
        let opaqueWeakReachability = Unmanaged<WeakReachability>.passUnretained(weakReachability).toOpaque()

        var context = SCNetworkReachabilityContext(
            version: 0,
            info: UnsafeMutableRawPointer(opaqueWeakReachability),
            retain: { info in
                let unmanagedWeakReachability = Unmanaged<WeakReachability>.fromOpaque(info)
                _ = unmanagedWeakReachability.retain()
                return UnsafeRawPointer(unmanagedWeakReachability.toOpaque())
            },
            release: { info in
                let unmanagedWeakReachability = Unmanaged<WeakReachability>.fromOpaque(info)
                unmanagedWeakReachability.release()
            },
            copyDescription: { info in
                let unmanagedWeakReachability = Unmanaged<WeakReachability>.fromOpaque(info)
                let weakReachability = unmanagedWeakReachability.takeUnretainedValue()
                let description = weakReachability.reachability.map(String.init(describing:)) ?? "nil"
                return Unmanaged.passRetained(description as CFString)
            }
        )
        guard SCNetworkReachabilitySetCallback(networkReachability, reachabilityCallback, &context) else {
            stopNotifier()
            return
        }
        guard SCNetworkReachabilitySetDispatchQueue(networkReachability, queue) else {
            stopNotifier()
            return
        }

        notifierIsRunning = true
        logger.debug("Started reachability notifier")

        return
    }

    private func stopNotifier() {
        defer { notifierIsRunning = false }
        guard let networkReachability else {
            return
        }

        logger.debug("Stopping reachability notifier")

        SCNetworkReachabilitySetCallback(networkReachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(networkReachability, nil)
    }

    private func updateFlags() {
        guard let networkReachability else {
            return
        }
        queue.sync {
            var flags = SCNetworkReachabilityFlags()
            guard SCNetworkReachabilityGetFlags(networkReachability, &flags) else {
                return stopNotifier()
            }
            self.flags = flags
        }
    }
}

private class WeakReachability {
    weak var reachability: ChartboostCoreNetworkStatusProvider?

    init(reachability: ChartboostCoreNetworkStatusProvider) {
        self.reachability = reachability
    }
}
