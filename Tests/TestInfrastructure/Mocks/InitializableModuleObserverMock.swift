// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class InitializableModuleObserverMock: InitializableModuleObserver {

    // MARK: - Call Counts and Return Values

    var onModuleInitializationCompletedCallCount = 0
    var onModuleInitializationCompletedResultLastValue: ModuleInitializationResult?

    // MARK: - SessionInfoProvider

    func onModuleInitializationCompleted(_ result: ModuleInitializationResult) {
        onModuleInitializationCompletedCallCount += 1
        onModuleInitializationCompletedResultLastValue = result
    }
}
