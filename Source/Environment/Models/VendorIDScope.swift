// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// The scope of a vendor identifier.
/// - note: This concept does not currently apply to iOS, but is included here
/// to match the definitions on the Android platform.
@objc(CBCVendorIDScope)
public enum VendorIDScope: Int {
    /// Unknown scope.
    case unknown

    /// Application scope.
    case application

    /// Developer scope.
    case developer
}

extension VendorIDScope: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown: return "unknown"
        case .application: return "application"
        case .developer: return "developer"
        }
    }
}
