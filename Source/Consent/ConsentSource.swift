// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// The source of a consent change.
@objc(CBCConsentSource)
public enum ConsentSource: Int, CustomStringConvertible {
    /// The consent was collected from the user as a result of an explicit user action.
    case user

    /// The consent was set by the developer without an explicit user action.
    case developer

    /// The string representation of the consent source.
    public var description: String {
        switch self {
        case .user: return "user"
        case .developer: return "developer"
        }
    }
}
