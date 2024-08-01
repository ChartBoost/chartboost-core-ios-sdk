// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class ModuleInitializerFactoryMock: ModuleInitializerFactory {
    var makeModuleInitializerCallCount = 0
    var makeModuleInitializerModuleAllValues: [Module] = []
    var makeModuleInitializerReturnValues: [ModuleInitializerMock] = []

    func reset() {
        makeModuleInitializerCallCount = 0
        makeModuleInitializerModuleAllValues = []
        makeModuleInitializerReturnValues = []
    }

    func makeModuleInitializer(module: Module) -> ModuleInitializer {
        makeModuleInitializerCallCount += 1
        makeModuleInitializerModuleAllValues.append(module)
        let returnValue = ModuleInitializerMock()
        makeModuleInitializerReturnValues.append(returnValue)
        return returnValue
    }
}
