// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class NetworkStatusProviderMock: NetworkStatusProvider {
    // MARK: - Call Counts and Return Values

    var startNotifierCallCount = 0

    // MARK: -

    var status: NetworkStatus = .reachableViaWWAN
    func startNotifier() {
        startNotifierCallCount += 1
    }
}
