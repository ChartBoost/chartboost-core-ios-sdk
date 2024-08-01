// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A component that publishes updates to observers whenever an environment property changes.
protocol EnvironmentChangePublisher {
    /// Adds an observer to receive notifications whenever an environment property changes.
    func addObserver(_ observer: EnvironmentObserver)

    /// Removes a previously-added observer.
    func removeObserver(_ observer: EnvironmentObserver)

    /// Notifies all observers of an environment property change.
    func publishChange(to property: ObservableEnvironmentProperty)
}
