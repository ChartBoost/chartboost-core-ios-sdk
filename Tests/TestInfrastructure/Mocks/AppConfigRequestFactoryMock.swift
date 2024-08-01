// Copyright 2023-2024 Chartboost, Inc.
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

    func makeRequest(
        configuration: SDKConfiguration,
        environment: AnalyticsEnvironment,
        completion: @escaping (_ request: AppConfigRequest) -> Void
    ) {
        makeRequestCallCount += 1
        makeRequestConfigurationLastValue = configuration
        makeRequestEnvironmentLastValue = environment
        DispatchQueue.main.async { [self] in
            completion(self.makeRequestReturnValue)
        }
    }
}
