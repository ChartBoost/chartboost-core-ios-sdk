// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class AppConfigRequestFactoryMock: AppConfigRequestFactory {

    // MARK: - Call Counts and Return Values

    var makeRequestCallCount = 0
    var makeRequestConfigurationLastValue: SDKConfiguration?
    var makeRequestEnvironmentLastValue: AnalyticsEnvironment?
    var makeRequestReturnValue = AppConfigRequest(body: nil)

    // MARK: - AppConfigRepository

    func makeRequest(configuration: SDKConfiguration, environment: AnalyticsEnvironment) -> AppConfigRequest {
        makeRequestCallCount += 1
        makeRequestConfigurationLastValue = configuration
        makeRequestEnvironmentLastValue = environment
        return makeRequestReturnValue
    }
}
