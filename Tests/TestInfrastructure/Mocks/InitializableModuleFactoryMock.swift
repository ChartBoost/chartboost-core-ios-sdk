// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class InitializableModuleFactoryMock: InitializableModuleFactory {

    // MARK: - Call Counts and Return Values

    var makeModuleCallCount = 0
    var makeModuleClassNameAllValues: [String] = []
    var makeModuleCredentialsAllValues: [[String: Any]?] = []
    var makeModuleReturnValues: [InitializableModuleMock] = []

    func reset() {
        makeModuleCallCount = 0
        makeModuleClassNameAllValues = []
        makeModuleCredentialsAllValues = []
        makeModuleReturnValues = []
    }

    // MARK: - AppConfigRepository

    func makeModule(className: String, credentials: [String: Any]?) -> InitializableModule? {
        makeModuleCallCount += 1
        makeModuleClassNameAllValues.append(className)
        makeModuleCredentialsAllValues.append(credentials)
        if makeModuleReturnValues.isEmpty {
            return nil
        } else {
            return makeModuleReturnValues.removeFirst()
        }
    }
}
