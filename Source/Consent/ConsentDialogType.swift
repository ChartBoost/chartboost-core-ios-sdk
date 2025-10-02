// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// The type of consent dialog to be presented to the user.
@objc(CBCConsentDialogType)
public enum ConsentDialogType: Int, CustomStringConvertible {
    /// A non-intrusive dialog used to collect consent, presenting a minimum amount of information.
    case concise

    /// A dialog used to collect consent, presenting detailed information and possibly allowing
    /// for granular consent choices.
    case detailed

    /// The string representation of the consent dialog type.
    public var description: String {
        switch self {
        case .concise: return "concise"
        case .detailed: return "detailed"
        }
    }
}
