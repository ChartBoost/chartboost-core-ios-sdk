// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A request that provides all the info needed to parse JSON data into its response model.
protocol URLResponseParseableJSONRequest {
    associatedtype ResponseBody: Decodable
    var responseKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
}

/// A parser that knows how to transform the JSON data obtained from a URL response into the Codable model
/// expected by a request that conforms to URLResponseParseableJSONRequest.
struct JSONURLResponseBodyParser<Request: HTTPRequest>: URLResponseBodyParser where Request: URLResponseParseableJSONRequest {

    static func parse(_ data: Data, for request: Request) throws -> Request.ResponseBody {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = request.responseKeyDecodingStrategy
        return try decoder.decode(Request.ResponseBody.self, from: data)
    }
}
