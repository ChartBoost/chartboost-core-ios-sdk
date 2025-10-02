// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Factory to instantiate a Core module using its class name via reflection.
/// - note: Users can generally ignore this protocol. It is intended to be used
/// only internally and by Chartboost's Core Unity wrapper.
@objc(CBCModuleFactory)
public protocol ModuleFactory {
    /// Returns a module instantiate via reflection.
    /// - parameter className: The name of the module class.
    /// - parameter credentials: The dictionary object to pass to ``Module/init(credentials:)``.
    /// - parameter completion: A closure that receives the generated module.
    func makeModule(className: String, credentials: [String: Any]?, completion: @escaping (Module?) -> Void)
}

/// Core's concrete implementation of ``ModuleFactory`` for native modules.
final class NativeModuleFactory: ModuleFactory {
    func makeModule(className: String, credentials: [String: Any]?, completion: @escaping (Module?) -> Void) {
        completion((NSClassFromString(className) as? Module.Type)?.init(credentials: credentials))
    }
}
