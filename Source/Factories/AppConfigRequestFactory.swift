// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// Factory to create an ``AppConfigRequest`` model using the information provided by
/// the publisher and the current environment.
protocol AppConfigRequestFactory {
    /// Returns a ``AppConfigRequest`` using the values in the passed `configuration` and `environment`.
    /// - parameter configuration: The SDK configuration object passed by the publisher on initialization.
    /// - parameter environment: The current analytics environment.
    /// - parameter completion: The async completion that returns the request.
    func makeRequest(
        configuration: SDKConfiguration,
        environment: AnalyticsEnvironment,
        completion: @escaping (_ request: AppConfigRequest) -> Void
    )
}

/// Core's concrete implementation of ``AppConfigRequestFactory``.
struct ChartboostCoreAppConfigRequestFactory: AppConfigRequestFactory {
    func makeRequest(
        configuration: SDKConfiguration,
        environment: AnalyticsEnvironment,
        completion: @escaping (_ request: AppConfigRequest) -> Void
    ) {
        // Use main thread to avoid accessing UIKit APIs from a background thread.
        DispatchQueue.main.async {
            let request = AppConfigRequest(
                body: .init(
                    configuration: .init(
                        app: .init(
                            bundleId: environment.bundleID,
                            publisherApplicationIdentifier: environment.publisherAppID,
                            version: environment.appVersion
                        ),
                        chartboostApplicationIdentifier: configuration.chartboostAppID,
                        coreVersion: ChartboostCore.sdkVersion,
                        framework: .init(
                            name: environment.frameworkName,
                            version: environment.osVersion
                        ),
                        player: .init(
                            playerId: environment.playerID
                        ),
                        schemaVersion: BackendSchemaVersion.config,
                        vendor: .init(
                            identifier: environment.vendorID,
                            scope: environment.vendorIDScope.description
                        )
                    ),
                    device: .init(
                        locale: environment.deviceLocale,
                        network: .init(
                            connectionType: environment.networkConnectionType.description
                        ),
                        os: .init(
                            name: environment.osName,
                            version: environment.osVersion
                        ),
                        screen: .init(
                            height: Int(environment.screenHeightPixels),
                            width: Int(environment.screenWidthPixels),
                            scale: environment.screenScale
                        ),
                        specifications: .init(
                            make: environment.deviceMake,
                            model: environment.deviceModel
                        )
                    )
                )
            )

            completion(request)
        }
    }
}
