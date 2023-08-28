// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A result object with the information regarding a module initialization operation.
@objc(CBCModuleInitializationResult)
@objcMembers
public final class ModuleInitializationResult: ChartboostCoreResult {

    /// The module that was initialized.
    /// Note that the initialization operation may have failed. Use the ``ChartboostCoreResult/error`` property to determine this.
    public let module: InitializableModule

    /// Initializes a result object with the provided information.
    init(
        startDate: Date,
        endDate: Date = Date(),
        error: Error?,
        module: InitializableModule
    ) {
        self.module = module
        super.init(startDate: startDate, endDate: endDate, error: error)
    }
}
