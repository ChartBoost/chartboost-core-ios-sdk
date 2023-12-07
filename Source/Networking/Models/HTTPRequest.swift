// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A HTTP request.
protocol HTTPRequest: CustomStringConvertible {

    /// The request body type. It might be a Codable model, just Data, or something else.
    associatedtype Body

    /// The expected response body type. Again it might be a Codable model, Data, etc.
    associatedtype ResponseBody

    /// The associated parser that knows how to transform the data obtained from a URL response into the request's body type.
    associatedtype ResponseBodyParser: URLResponseBodyParser where ResponseBodyParser.Request == Self

    /// The associated builder that knows how to generate a URLRequest from the request.
    associatedtype RequestBuilder: URLRequestBuilder where RequestBuilder.Request == Self

    /// The URL.
    var url: URL { get throws }

    /// The HTTP method such as "GET" and "POST".
    var method: HTTPMethod { get }

    /// A dictionary of custom HTTP headers.
    var headers: HTTPHeaders { get }

    /// The optional request body.
    var body: Body? { get throws }
}

extension HTTPRequest {

    var description: String {
        "\(method): \((try? url)?.absoluteString ?? "bad URL")"
    }

    var headers: HTTPHeaders {
        [:]
    }
}
