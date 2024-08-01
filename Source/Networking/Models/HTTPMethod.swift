// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A HTTP method.
enum HTTPMethod: String, CaseIterable, CustomStringConvertible {
    case get = "GET"
    case post = "POST"

    var description: String {
        rawValue
    }
}
