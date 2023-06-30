// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objc(ChartboostCoreModuleInitializationResult)
@objcMembers
public final class ModuleInitializationResult: ChartboostCoreResult {
    public let module: InitializableModule

    internal init(
        startDate: Date,
        endDate: Date = Date(),
        error: Error?,
        module: InitializableModule
    ) {
        self.module = module
        super.init(startDate: startDate, endDate: endDate, error: error)
    }
}
