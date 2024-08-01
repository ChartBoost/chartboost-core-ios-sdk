// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A result object with the information regarding a module initialization operation.
@objc(CBCModuleInitializationResult)
@objcMembers
public final class ModuleInitializationResult: ChartboostCoreResult {
    /// The identifier of the module that was attempted to be initialized.
    /// - note: The initialization operation may have failed. Use the ``ChartboostCoreResult/error`` property to determine this.
    public let moduleID: String

    /// The version of the module that was attempted to be initialized.
    /// - note: The initialization operation may have failed. Use the ``ChartboostCoreResult/error`` property to determine this.
    public let moduleVersion: String

    /// Initializes a result object with the provided information.
    init(
        startDate: Date,
        endDate: Date = Date(),
        error: Error?,
        module: Module
    ) {
        self.moduleID = module.moduleID
        self.moduleVersion = module.moduleVersion
        super.init(startDate: startDate, endDate: endDate, error: error)
    }
}
