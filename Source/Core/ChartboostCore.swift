// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// The main interface to the Chartboost Core SDK.
/// Provides users with access to all of Core's functionalities.
@objcMembers
public final class ChartboostCore: NSObject {
    @Injected(\.advertisingEnvironment) private static var sharedAdvertisingEnvironment
    @Injected(\.analyticsEnvironment) private static var sharedAnalyticsEnvironment
    @Injected(\.attributionEnvironment) private static var sharedAttributionEnvironment
    @Injected(\.consentManager) private static var consentManager
    @Injected(\.moduleFactory) private static var moduleFactory
    @Injected(\.sdkInitializer) private static var sdkInitializer

    /// The version of the Core SDK.
    public static let sdkVersion = "1.1.0"

    /// Publisher-provided metadata.
    public static let publisherMetadata = PublisherMetadata()

    /// The environment that contains information intended solely for advertising purposes.
    public static var advertisingEnvironment: AdvertisingEnvironment {
        sharedAdvertisingEnvironment
    }

    /// The environment that contains information intended solely for analytics purposes.
    public static var analyticsEnvironment: AnalyticsEnvironment {
        sharedAnalyticsEnvironment
    }

    /// The environment that contains information intended solely for attribution purposes.
    public static var attributionEnvironment: AttributionEnvironment {
        sharedAttributionEnvironment
    }

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
    /// - Initialize all the provided modules (both the ones explicitly passed in `configuration` and then
    /// those defined on the dashboard, skipping duplicates).
    /// - Keep all modules successfully initialized alive by creating strong references to them.
    /// - Set a module that conforms to ``ConsentAdapter`` as the backing CMP for ``ChartboostCore/consent``,
    /// and thus enabling CMP functionalities.
    ///
    /// - parameter configuration: Initialization configuration parameters.
    /// - parameter moduleObserver: An observer to be notified whenever a Core module finishes initialization.
    @objc(initializeSDKWithConfiguration:moduleObserver:)
    public static func initializeSDK(configuration: SDKConfiguration, moduleObserver: ModuleObserver?) {
        sdkInitializer.initializeSDK(configuration: configuration, moduleObserver: moduleObserver)
    }

    /// The Chartboost Core console log level.
    ///
    /// Defaults to ``LogLevel/info``.
    public static var logLevel: LogLevel {
        get { ConsoleLogHandler.core.logLevel }
        set { ConsoleLogHandler.core.logLevel = newValue }
    }

    /// Attach a custom logger handler to the logging system.
    /// - Parameter handler: A custom class that conforms to the ``LogHandler`` protocol.
    public static func attachLogHandler(_ handler: LogHandler) {
        logger.attachHandler(handler)
    }

    /// Detach a custom logger handler from the logging system.
    /// - Parameter handler: A custom class that conforms to the ``LogHandler`` protocol.
    public static func detachLogHandler(_ handler: LogHandler) {
        logger.detachHandler(handler)
    }

    /// The factory intended to instantiate non-native (e.g. Unity) remote modules during initialization.
    /// It should only be set by the framework wrapper (e.g. Core Unity wrapper) using reflection.
    /// Private to prevent others from setting it.
    @objc private static var nonNativeModuleFactory: ModuleFactory? {
        get { moduleFactory.nonNativeModuleFactory }
        set { moduleFactory.nonNativeModuleFactory = newValue }
    }

    // Make NSObject init private to prevent users from instantiating this class.
    override private init() {
        super.init()
    }
}
