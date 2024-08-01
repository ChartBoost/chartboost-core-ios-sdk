// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A factory to generate module initializer instances.
protocol ModuleInitializerFactory {
    /// Returns a module initializer ready to initialize the module provided.
    /// - parameter module: The module to be initialized by the initializer.
    func makeModuleInitializer(module: Module) -> ModuleInitializer
}

/// Core's concrete implementation of ``ModuleInitializerFactory``.
struct ChartboostCoreModuleInitializerFactory: ModuleInitializerFactory {
    /// Shared queue for all module initializers to prevent too many queues from being created
    /// for a high number of modules.
    private static let queue = DispatchQueue(label: "com.chartboost.core.module_initializer")

    func makeModuleInitializer(module: Module) -> ModuleInitializer {
        ChartboostCoreModuleInitializer(module: module, queue: Self.queue)
    }
}
