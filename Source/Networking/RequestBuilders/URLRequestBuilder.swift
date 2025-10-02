// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A builder that knows how to make URL requests from another request model (e.g. a HTTPRequest).
protocol URLRequestBuilder {
    /// The associated request type.
    associatedtype Request

    /// Makes a URL request using the info provided by a request model.
    static func makeURLRequest(from request: Request) throws -> URLRequest
}

// Convenience extension
extension URLRequestBuilder where Request: HTTPRequest {
    /// Creates a URL request with the info provided by a HTTPRequest.
    /// This is a base method intended to be used by types conforming to URLRequestBuilder which should provide
    /// the extra info specific to the type of HTTPRequest they deal with.
    static func makeURLRequest(from request: Request, extraHeaders: HTTPHeaders, body: Data?) throws -> URLRequest {
        var urlRequest = URLRequest(url: try request.url)
        urlRequest.allHTTPHeaderFields = request.headers.merging(extraHeaders, uniquingKeysWith: { first, _ in first })
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = body
        return urlRequest
    }
}
