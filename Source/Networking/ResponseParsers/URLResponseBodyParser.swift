// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A parser that knows how to transform the data obtained from a URL response into the request's response body type.
protocol URLResponseBodyParser {
    /// The associated request type.
    associatedtype Request: HTTPRequest

    /// Transforms some data into the response model expected by the request.
    static func parse(_ data: Data, for request: Request) throws -> Request.ResponseBody
}
