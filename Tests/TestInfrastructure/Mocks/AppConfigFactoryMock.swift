// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class AppConfigFactoryMock: AppConfigFactory {

    // MARK: - Call Counts and Return Values

    var makeAppConfigCallCount = 0
    var makeAppConfigResponseLastValue: AppConfigRequest.ResponseBody?
    var makeAppConfigFallbackValuesLastValue: AppConfig?
    var makeAppConfigReturnValue: AppConfig = .build()

    // MARK: - AppConfigFactory

    func makeAppConfig(from response: AppConfigRequest.ResponseBody, fallbackValues: AppConfig) -> AppConfig {
        makeAppConfigCallCount += 1
        makeAppConfigResponseLastValue = response
        makeAppConfigFallbackValuesLastValue = fallbackValues
        return makeAppConfigReturnValue
    }
}
