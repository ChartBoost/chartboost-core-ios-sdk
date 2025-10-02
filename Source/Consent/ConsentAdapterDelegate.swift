// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// The delegate of a ``ConsentAdapter`` module.
/// It should get notified whenever any change happens in the CMP consent.
@objc(CBCConsentAdapterDelegate)
public protocol ConsentAdapterDelegate: AnyObject {
    /// Called whenever the ``ConsentAdapter/consents`` value changed.
    /// - parameter key: The key that changed.
    func onConsentChange(key: ConsentKey)
}
