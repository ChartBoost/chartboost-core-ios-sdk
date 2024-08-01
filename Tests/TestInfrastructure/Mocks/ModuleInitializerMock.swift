// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class ModuleInitializerMock: ModuleInitializer {
    var initializeCallCount = 0
    var initializeConfigurationLastValue: ModuleConfiguration?
    var initializeCompletionLastValue: ((ModuleInitializationResult) -> Void)?

    var module: Module = ModuleMock()

    func initialize(
        configuration: ModuleConfiguration,
        completion: @escaping (ModuleInitializationResult) -> Void
    ) {
        initializeCallCount += 1
        initializeConfigurationLastValue = configuration
        initializeCompletionLastValue = completion
    }
}
