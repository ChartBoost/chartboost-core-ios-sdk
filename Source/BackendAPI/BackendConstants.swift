// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A namespace for all backend endpoints used by the Core SDK.
enum BackendEndpoint {
    /// The URL for the initialization endpoint used to fetch an app config.
    static let initialize = URL(string: "https://us-central1-helium-staging-01.cloudfunctions.net/init")!
}

/// A namespace for all backend endpoint schema versions used by the Core SDK.
enum BackendSchemaVersion {
    /// The schema version for the initialization backend endpoint.
    static let initialize = "1.0"
}
