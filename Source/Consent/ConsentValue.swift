// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A value in a Core consents dictionary.
public typealias ConsentValue = String

/// A namespace for Core's predefined ``ConsentValue`` constants.
@objc(CBCConsentValues)
@objcMembers
public final class ConsentValues: NSObject {
    /// Indicates the user denied consent.
    public static let denied: ConsentValue = "denied"

    /// Indicates the standard does not apply.
    public static let doesNotApply: ConsentValue = "does_not_apply"

    /// Indicates the user granted consent.
    public static let granted: ConsentValue = "granted"

    @available(*, unavailable)
    override init() {
        fatalError("Instantiation is disallowed because this class is intended only to act as a namespace.")
    }
}
