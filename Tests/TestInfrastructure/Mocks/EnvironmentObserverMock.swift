// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

class EnvironmentObserverMock: EnvironmentObserver {
    // MARK: - Call Counts and Return Values

    var onChangeCallCount = 0
    var onChangePropertyLastValue: ObservableEnvironmentProperty?

    // MARK: - EnvironmentObserver

    func onChange(_ property: ObservableEnvironmentProperty) {
        onChangeCallCount += 1
        onChangePropertyLastValue = property
    }
}
