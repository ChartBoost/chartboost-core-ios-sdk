// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A HTTP request with a JSON body and JSON response.
protocol HTTPJSONRequest:
    HTTPRequest,
    URLRequestBuildableJSONRequest,
    URLResponseParseableJSONRequest
where Body: Encodable,
      ResponseBody: Decodable,
      ResponseBodyParser == JSONURLResponseBodyParser<Self>,
      RequestBuilder == JSONURLRequestBuilder<Self> {
    /// The key encoding strategy to be used when encoding the body to JSON.
    var bodyKeyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { get }

    /// The key decoding strategy to be used when decoding the response from JSON.
    var responseKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
}

extension HTTPJSONRequest {
    // Required to conform to URLRequestBuildableJSONRequest.
    var acceptsJSONResponse: Bool { true }

    // Default key encoding strategy.
    var bodyKeyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { .useDefaultKeys }

    // Default key decoding strategy.
    var responseKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { .useDefaultKeys }
}
