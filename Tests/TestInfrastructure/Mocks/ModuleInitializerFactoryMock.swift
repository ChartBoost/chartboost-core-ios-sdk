// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class ModuleInitializerFactoryMock: ModuleInitializerFactory {

    var makeModuleInitializerCallCount = 0
    var makeModuleInitializerModuleAllValues: [InitializableModule] = []
    var makeModuleInitializerReturnValues: [ModuleInitializerMock] = []

    func reset() {
        makeModuleInitializerCallCount = 0
        makeModuleInitializerModuleAllValues = []
        makeModuleInitializerReturnValues = []
    }

    func makeModuleInitializer(module: InitializableModule) -> ModuleInitializer {
        makeModuleInitializerCallCount += 1
        makeModuleInitializerModuleAllValues.append(module)
        let returnValue = ModuleInitializerMock()
        makeModuleInitializerReturnValues.append(returnValue)
        return returnValue
    }
}
