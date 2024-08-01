// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class ModuleFactoryMock: ModuleFactory {
    // MARK: - Call Counts and Return Values

    var makeModuleCallCount = 0
    var makeModuleClassNameAllValues: [String] = []
    var makeModuleCredentialsAllValues: [[String: Any]?] = []
    var makeModuleReturnValues: [ModuleMock] = []

    func reset() {
        makeModuleCallCount = 0
        makeModuleClassNameAllValues = []
        makeModuleCredentialsAllValues = []
        makeModuleReturnValues = []
    }

    // MARK: - AppConfigRepository

    func makeModule(className: String, credentials: [String: Any]?, completion: @escaping (Module?) -> Void) {
        makeModuleCallCount += 1
        makeModuleClassNameAllValues.append(className)
        makeModuleCredentialsAllValues.append(credentials)
        if makeModuleReturnValues.isEmpty {
            completion(nil)
        } else {
            completion(makeModuleReturnValues.removeFirst())
        }
    }
}
