// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class ModuleInitializerMock: ModuleInitializer {

    var initializeCallCount = 0
    var initializeCompletionLastValue: ((ModuleInitializationResult) -> Void)?

    var module: InitializableModule = InitializableModuleMock()

    func initialize(
        configuration: ModuleInitializationConfiguration,
        completion: @escaping (ModuleInitializationResult) -> Void
    ) {
        initializeCallCount += 1
        initializeCompletionLastValue = completion
    }
}
