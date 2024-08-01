// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class UniversalModuleFactoryMock: UniversalModuleFactory {
    // MARK: - Call Counts and Return Values

    var makeModuleCallCount = 0
    var makeModuleInfoAllValues: [AppConfig.ModuleInfo] = []
    var makeModuleReturnValues: [ModuleMock] = []

    func reset() {
        makeModuleCallCount = 0
        makeModuleInfoAllValues = []
        makeModuleReturnValues = []
    }

    // MARK: - AppConfigRepository

    var nonNativeModuleFactory: ModuleFactory?

    func makeModule(info: AppConfig.ModuleInfo, completion: @escaping (Module?) -> Void) {
        makeModuleCallCount += 1
        makeModuleInfoAllValues.append(info)
        if makeModuleReturnValues.isEmpty {
            completion(nil)
        } else {
            completion(makeModuleReturnValues.removeFirst())
        }
    }
}
