// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// An observer that gets notified when the value of some observable environment field changes.
@objc(CBCEnvironmentObserver)
public protocol EnvironmentObserver: AnyObject {
    /// Called every time there's a change in the value of one of the environment properties with a
    /// ``ObservableEnvironmentProperty`` counterpart.
    /// - parameter property: A constant that identifies the environment property that changed.
    /// Note that in order to access the new value for that field you'll have to go through the Core environment.
    func onChange(_ property: ObservableEnvironmentProperty)
}
