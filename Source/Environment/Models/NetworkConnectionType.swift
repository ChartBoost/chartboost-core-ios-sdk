// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Network connection type.
@objc(CBCNetworkConnectionType)
public enum NetworkConnectionType: Int {

    /// Unknown connection type.
    case unknown

    /// Wired network connection.
    case wired

    /// WiFi network connection.
    case wifi

    /// Cellular network connection of unknown generation.
    case cellularUnknown

    /// 2G cellular network connection.
    case cellular2G

    /// 3G cellular network connection.
    case cellular3G

    /// 4G cellular network connection.
    case cellular4G

    /// 5G cellular network connection.
    case cellular5G

    /// String representation of the type.
    var description: String {
        switch self {
        case .unknown: return "unknown"
        case .wired: return "wired"
        case .wifi: return "wifi"
        case .cellularUnknown: return "cellularUnknown"
        case .cellular2G: return "cellular2G"
        case .cellular3G: return "cellular3G"
        case .cellular4G: return "cellular4G"
        case .cellular5G: return "cellular5G"
        }
    }
}
