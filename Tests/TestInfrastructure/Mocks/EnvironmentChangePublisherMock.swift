// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

class EnvironmentChangePublisherMock: EnvironmentChangePublisher {
    // MARK: - Call Counts and Return Values

    var addObserverCallCount = 0
    var addObserverLastValue: EnvironmentObserver?
    var removeObserverCallCount = 0
    var removeObserverLastValue: EnvironmentObserver?
    var publishChangeCallCount = 0
    var publishChangePropertyLastValue: ObservableEnvironmentProperty?

    // MARK: - EnvironmentChangePublisher

    func addObserver(_ observer: EnvironmentObserver) {
        addObserverCallCount += 1
        addObserverLastValue = observer
    }

    func removeObserver(_ observer: EnvironmentObserver) {
        removeObserverCallCount += 1
        removeObserverLastValue = observer
    }

    func publishChange(to property: ObservableEnvironmentProperty) {
        publishChangeCallCount += 1
        publishChangePropertyLastValue = property
    }
}
