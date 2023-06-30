// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objcMembers
public final class ChartboostCore: NSObject {

    @Injected(\.environment) private static var environment
    @Injected(\.sdkInitializer) private static var sdkInitializer

    public static let publisherMetadata = PublisherMetadata.self

    public static var advertisingEnvironment: AdvertisingEnvironment {
        environment
    }
    public static var analyticsEnvironment: AnalyticsEnvironment {
        environment
    }
    public static var attributionEnvironment: AttributionEnvironment {
        environment
    }

    public static var consent: ConsentManagementPlatform? {
        // TODO: Implement
        nil
    }

    public static func initializeSDK(
        with configuration: SDKConfiguration,
        modules: [InitializableModule] = [],
        moduleObserver: InitializableModuleObserver? = nil,
        completion: @escaping (_ result: SDKInitializationResult) -> Void
    ) {
        sdkInitializer.initializeSDK(with: configuration, modules: modules, moduleObserver: moduleObserver, completion: completion)
    }

    public static var sdkVersion: String {
        "0.1.0" // this is replaced by our scripts when generating a new release branch, together with the podspec version
    }
}
