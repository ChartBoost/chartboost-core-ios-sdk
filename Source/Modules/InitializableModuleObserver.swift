// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objc(ChartboostCoreInitializableModuleObserver)
public protocol InitializableModuleObserver {
    func onModuleInitializationCompleted(_ result: ModuleInitializationResult)
}
