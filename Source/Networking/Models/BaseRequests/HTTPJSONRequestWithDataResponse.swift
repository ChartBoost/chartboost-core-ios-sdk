// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A HTTP request with a JSON body and a Data response.
protocol HTTPJSONRequestWithDataResponse:
    HTTPRequest,
    URLRequestBuildableJSONRequest
where Body: Encodable,
      ResponseBody == Data,
      RequestBuilder == JSONURLRequestBuilder<Self>,
      ResponseBodyParser == DataURLResponseBodyParser<Self>
{
    /// The key encoding strategy to be used when encoding the body to JSON.
    var bodyKeyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { get }
}

extension HTTPJSONRequestWithDataResponse {
    // Required to conform to URLRequestBuildableJSONRequest.
    var acceptsJSONResponse: Bool { false }

    // Default key encoding strategy.
    var bodyKeyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { .useDefaultKeys }
}
