// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A HTTP request to obtain the app configuration required to initialize the Core SDK.
struct AppConfigRequest: HTTPJSONRequest, Equatable {
    /// The request URL.
    let url = BackendEndpoint.config

    /// The request HTTP method.
    let method: HTTPMethod = .post

    /// The request body.
    let body: Body?
}

// MARK: Request Body

extension AppConfigRequest {
    /// An encodable definition of the body included in ``AppConfigRequest`` sent to the backend.
    struct Body: Encodable, Equatable {
        struct Configuration: Encodable, Equatable {
            struct App: Encodable, Equatable {
                let bundleId: String?
                let publisherApplicationIdentifier: String?
                let version: String?
            }

            struct Framework: Encodable, Equatable {
                let name: String?
                let version: String?
            }

            struct Player: Encodable, Equatable {
                let playerId: String?
            }

            struct Vendor: Encodable, Equatable {
                let identifier: String?
                let scope: String?
            }

            let app: App
            let chartboostApplicationIdentifier: String
            let coreVersion: String
            let framework: Framework
            let player: Player
            let schemaVersion: String
            let vendor: Vendor
        }

        struct Device: Encodable, Equatable {
            struct Network: Encodable, Equatable {
                let connectionType: String?
            }

            struct OS: Encodable, Equatable {
                let name: String
                let version: String
            }

            struct Screen: Encodable, Equatable {
                let height: Int
                let width: Int
                let scale: Double
            }

            struct Specifications: Encodable, Equatable {
                let make: String
                let model: String
            }

            let locale: String?
            let network: Network
            let os: OS
            let screen: Screen
            let specifications: Specifications
        }

        let configuration: Configuration
        let device: Device
    }
}

// MARK: Response Body

extension AppConfigRequest {
    /// A decodable definition of the response body expected in a ``AppConfigRequest`` response from backend.
    struct ResponseBody: Decodable, Equatable {
        struct PlatformContainer: Decodable, Equatable {
            struct Module: Decodable, Equatable {
                struct Config: Decodable, Equatable {
                    let version: String?
                    let params: JSON<[String: Any]>?
                }

                let className: String?
                let nonNativeClassName: String?
                let config: Config?
                let id: String
            }

            let consentUpdateBatchDelayMs: Int?
            let coreInitializationDelayBaseMs: Int?
            let coreInitializationDelayMaxMs: Int?
            let coreInitializationRetryCountMax: Int?
            let logLevel: String?
            let moduleInitializationDelayBaseMs: Int?
            let moduleInitializationDelayMaxMs: Int?
            let moduleInitializationRetryCountMax: Int?
            let schemaVersion: String?
            let modules: [Module]?
        }

        let ios: PlatformContainer?
    }
}
