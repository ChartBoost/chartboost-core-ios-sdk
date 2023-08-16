// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A request that provides all the info needed to build a URL request from it.
protocol URLRequestBuildableJSONRequest {

    /// The associated request body type.
    associatedtype Body: Encodable

    /// The request body.
    var body: Body? { get }

    /// The key encoding strategy to be used when encoding the body to JSON.
    var bodyKeyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { get }

    /// Indicates if the request accepts a JSON response.
    var acceptsJSONResponse: Bool { get }
}

/// A builder that knows how to make URL requests from a JSON request model that conforms to URLRequestBuildableJSONRequest.
struct JSONURLRequestBuilder<Request: HTTPRequest>: URLRequestBuilder where Request: URLRequestBuildableJSONRequest {

    /// Returns a `URLRequest` using the information provided by a ``HTTPRequest`` with a JSON-decodable body.
    static func makeURLRequest(from request: Request) throws -> URLRequest {
        try makeURLRequest(
            from: request,
            extraHeaders: makeHeaders(from: request),
            body: try makeBody(from: request)
        )
    }

    private static func makeBody(from request: Request) throws -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = request.bodyKeyEncodingStrategy
        encoder.outputFormatting = .sortedKeys
        return try encoder.encode(request.body)
    }

    private static func makeHeaders(from request: Request) -> HTTPHeaders {
        var headers: HTTPHeaders = [HTTPHeaderKey.contentType: HTTPHeaderValue.applicationJSONChartsetUTF8]
        if request.acceptsJSONResponse {
            headers[HTTPHeaderKey.accept] = HTTPHeaderValue.applicationJSONChartsetUTF8
        }
        return headers
    }
}
