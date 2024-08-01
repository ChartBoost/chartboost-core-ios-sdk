// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class AppConfigRepositoryMock: AppConfigRepository {
    // MARK: - Call Counts and Return Values

    var fetchAppConfigCallCount = 0
    var fetchAppConfigConfigurationLastValue: SDKConfiguration?
    var fetchAppConfigCompletionLastValue: ((Error?) -> Void)?

    // MARK: - AppConfigRepository

    var config = AppConfig.build()

    func fetchAppConfig(configuration: SDKConfiguration, completion: @escaping (Error?) -> Void) {
        fetchAppConfigCallCount += 1
        fetchAppConfigConfigurationLastValue = configuration
        fetchAppConfigCompletionLastValue = completion
    }
}
