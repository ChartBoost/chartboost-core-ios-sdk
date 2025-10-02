// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Factory to instantiate a Core module, regardless of if it's a native or non-native module.
protocol UniversalModuleFactory: AnyObject {
    /// The factory intended to instantiate non-native modules.
    /// A variable because it's intended to be set by the non-native (e.g. Unity) wrapper at some
    /// arbitrary point before initialization.
    var nonNativeModuleFactory: ModuleFactory? { get set }

    /// Returns a module instantiate via reflection.
    /// - parameter info: The info needed to instantiate the module.
    /// - parameter completion: A closure that receives the generated module.
    func makeModule(info: AppConfig.ModuleInfo, completion: @escaping (Module?) -> Void)
}

/// Core's concrete implementation of ``UniversalModuleFactory``.
final class ChartboostCoreUniversalModuleFactory: UniversalModuleFactory {
    private struct ModuleInstantiationInfo {
        let factory: ModuleFactory
        let className: String
        let credentials: [String: Any]?
    }

    /// The factory intended to instantiate native modules.
    let nativeModuleFactory: ModuleFactory

    /// The factory intended to instantiate non-native modules.
    /// A variable because it's intended to be set by the non-native (e.g. Unity) wrapper at some
    /// arbitrary point before initialization.
    var nonNativeModuleFactory: ModuleFactory?

    init(nativeModuleFactory: ModuleFactory) {
        self.nativeModuleFactory = nativeModuleFactory
    }

    func makeModule(info: AppConfig.ModuleInfo, completion: @escaping (Module?) -> Void) {
        guard let instantiationInfo = moduleInstantiationInfo(for: info) else {
            completion(nil)
            return
        }
        instantiationInfo.factory.makeModule(
            className: instantiationInfo.className,
            credentials: instantiationInfo.credentials,
            completion: completion
        )
    }

    private func moduleInstantiationInfo(for moduleInfo: AppConfig.ModuleInfo) -> ModuleInstantiationInfo? {
        if let nativeClassName = moduleInfo.className {
            // Native module
            return ModuleInstantiationInfo(
                factory: nativeModuleFactory,
                className: nativeClassName,
                credentials: moduleInfo.credentials?.value
            )
        } else if let nonNativeClassName = moduleInfo.nonNativeClassName {
            // Non-native module, that the non-native wrapper itself needs to instantiate
            if let nonNativeModuleFactory {
                return ModuleInstantiationInfo(
                    factory: nonNativeModuleFactory,
                    className: nonNativeClassName,
                    credentials: moduleInfo.credentials?.value
                )
            } else {
                // Non-native module obtained from backend config for app that does not use the non-native wrapper
                logger.error("Received non-native module but non-native module factory is not set")
            }
        } else {
            // Invalid backend config
            logger.error("Invalid module info with no class name")
        }
        return nil
    }
}
