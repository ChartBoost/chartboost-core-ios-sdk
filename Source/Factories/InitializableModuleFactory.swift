// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Factory to instantiate a Core module using its class name via reflection.
protocol InitializableModuleFactory {

    /// Returns a module instantiate via reflection.
    /// - parameter className: The name of the module class.
    /// - parameter credentials: The dictionary object to pass to ``InitializableModule.init(credentials:)``.
    func makeModule(className: String, credentials: [String: Any]?) -> InitializableModule?
}

/// Core's concrete implementation of ``InitializableModuleFactory``.
struct ChartboostCoreInitializableModuleFactory: InitializableModuleFactory {

    func makeModule(className: String, credentials: [String: Any]?) -> InitializableModule? {
        (NSClassFromString(className) as? InitializableModule.Type)?.init(credentials: credentials)
    }
}
