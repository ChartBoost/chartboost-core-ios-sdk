// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// The main interface to the Chartboost Core SDK.
/// Provides users with access to all of Core's functionalities.
@objcMembers
public final class ChartboostCore: NSObject {

    @Injected(\.consentManager) private static var consentManager

    @Injected(\.sdkInitializer) private static var sdkInitializer

    /// Publisher-provided metadata.
    public static let publisherMetadata = PublisherMetadata()

    /// The environment that contains information intended solely for advertising purposes.
    public static let advertisingEnvironment: AdvertisingEnvironment = Environment(purpose: .advertising)

    /// The environment that contains information intended solely for analytics purposes.
    public static let analyticsEnvironment: AnalyticsEnvironment = Environment(purpose: .analytics)

    /// The environment that contains information intended solely for attribution purposes.
    public static let attributionEnvironment: AttributionEnvironment = Environment(purpose: .attribution)

    /// The CMP in charge of handling user consent.
    public static var consent: ConsentManagementPlatform {
        consentManager
    }

    /// Initializes the Core SDK and its modules.
    ///
    /// As part of initialization Core will:
    /// - Fetch an app config from the Chartboost Core dashboard with all the info needed for Core and its
    /// modules to function.
    /// - Instantiate modules defined on the Charboost Core dashboard.
    /// - Initialize all the provided modules (both the ones explicitly passed on a call to this method and
    /// those defined on the dashboard, skipping duplicates).
    /// - Keep all modules successfully initialized alive by creating strong references to them.
    /// - Set a module that conforms to ``ConsentAdapter`` as the backing CMP for ``ChartboostCore/consent``,
    /// and thus enabling CMP functionalities.
    ///
    /// - parameter configuration: Initialization configuration parameters.
    /// - parameter modules: Optional list of modules to be initialized and managed by the Core SDK.
    /// You may skip this parameter if you rely on modules defined on Chartboost Core's dashboard.
    /// - parameter moduleObserver: An observer to be notified whenever a Core module finishes initialization.
    @objc(initializeSDKWithConfiguration:modules:moduleObserver:)
    public static func initializeSDK(
        with configuration: SDKConfiguration,
        modules: [InitializableModule],
        moduleObserver: InitializableModuleObserver?
    ) {
        sdkInitializer.initializeSDK(with: configuration, modules: modules, moduleObserver: moduleObserver)
    }

    /// Initializes the Core SDK and its modules.
    ///
    /// As part of initialization Core will:
    /// - Fetch an app config from the Chartboost Core dashboard with all the info needed for Core and its
    /// modules to function.
    /// - Instantiate and initialize modules defined on the Charboost Core dashboard.
    /// - Set a module that conforms to ``ConsentAdapter`` as the backing CMP for ``ChartboostCore/consent``,
    /// and thus enabling CMP functionalities.
    ///
    /// - parameter configuration: Initialization configuration parameters.
    /// - parameter moduleObserver: An observer to be notified whenever a Core module finishes initialization.
    @objc(initializeSDKWithConfiguration:moduleObserver:)
    public static func initializeSDK(
        with configuration: SDKConfiguration,
        moduleObserver: InitializableModuleObserver?
    ) {
        sdkInitializer.initializeSDK(with: configuration, modules: [], moduleObserver: moduleObserver)
    }

    /// The version of the Core SDK.
    public static var sdkVersion: String {
        "0.2.0" // this is replaced by our scripts when generating a new release branch, together with the podspec version
    }

    // Make NSObject init private to prevent users from instantiating this class.
    override private init() {
        super.init()
    }
}
