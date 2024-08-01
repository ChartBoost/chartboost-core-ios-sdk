// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A namespace for all backend endpoints used by the Core SDK.
enum BackendEndpoint {
    /// The URL for the initialization endpoint used to fetch an app config.
    static let config = URL(safeString: "https://config.core-sdk.chartboost.com/v1/core_config")
}

/// A namespace for all backend endpoint schema versions used by the Core SDK.
enum BackendSchemaVersion {
    /// The schema version for the config backend endpoint.
    static let config = "1.0"
}
