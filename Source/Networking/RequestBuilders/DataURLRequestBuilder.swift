// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A builder that knows how to make URL requests from a HTTP request with a Data body.
struct DataURLRequestBuilder<Request: HTTPRequest>: URLRequestBuilder where Request.Body == Data {

    /// Returns a `URLRequest` using the information provided by a ``HTTPRequest`` with a `Data` body.
    static func makeURLRequest(from request: Request) throws -> URLRequest {
        try makeURLRequest(
            from: request,
            extraHeaders: [:],
            body: try request.body
        )
    }
}
