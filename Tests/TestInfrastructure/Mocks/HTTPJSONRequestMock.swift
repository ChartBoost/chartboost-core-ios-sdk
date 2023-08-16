// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

/// A basic HTTP JSON request.
struct HTTPJSONRequestMock: HTTPJSONRequest, URLResponseParseableJSONRequest {
    let url = URL(string: "www.chartboost.com")!
    let method = HTTPMethod.get
    let headers: HTTPHeaders = ["some header": "value1", "another header": "value2"]
    let body: Body? = Body(field1: "some value", field2: 42, field3: ["1", "2", "3"])
    let bodyKeyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase
    let responseKeyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    let acceptsJSONResponse: Bool

    struct Body: Codable {
        let field1: String
        let field2: Int
        let field3: [String]
    }

    struct ResponseBody: Codable, Equatable {
        let field4: String
        let field5: Int
    }
}
