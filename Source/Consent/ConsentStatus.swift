// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// User consent status.
@objc(CBCConsentStatus)
public enum ConsentStatus: Int, Codable, CustomStringConvertible {

    /// Indicates that the consent is unknown, possibly because the user was never asked for consent.
    case unknown = -1

    /// Indicates the user denied consent.
    case denied

    /// Indicates the user granted consent.
    case granted

    /// The string representation of the consent status.
    public var description: String {
        switch self {
        case .unknown: return "unknown"
        case .denied: return "denied"
        case .granted: return "granted"
        }
    }
}
