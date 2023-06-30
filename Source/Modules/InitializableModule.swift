// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objc(ChartboostCoreInitializableModule)
public protocol InitializableModule: Module {
    func initialize(
        with configuration: ModuleConfiguration,
        completion: @escaping (ModuleInitializationResult) -> Void
    )
}
