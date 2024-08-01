// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Network reachability status.
enum NetworkStatus: Int {
    // The network status is unknown.
    case unknown = -1

    /// The network is not reachable.
    case notReachable = 0

    /// The network is reachable via WiFi.
    case reachableViaWiFi = 1

    /// The network is reachable via WWAN (Wireless Wide Area Network, typically cellular).
    case reachableViaWWAN = 2
}
