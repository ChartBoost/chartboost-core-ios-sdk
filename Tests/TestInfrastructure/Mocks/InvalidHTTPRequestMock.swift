// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

/// A HTTP request that can be set so its URL request builder or response body parser always fail.
struct InvalidHTTPRequestMock: HTTPRequest {

    let url = URL(string: "www.chartboost.com")!
    let method = HTTPMethod.get
    let body = "some data".data(using: .utf8)

    let makeURLRequestError: Error?
    let parseResponseBodyError: Error?

    typealias Body = Data
    typealias ResponseBody = Data

    struct RequestBuilder: URLRequestBuilder {

        static func makeURLRequest(from request: InvalidHTTPRequestMock) throws -> URLRequest {
            if let error = request.makeURLRequestError {
                throw error
            } else {
                return URLRequest(url: request.url)
            }
        }
    }

    struct ResponseBodyParser: URLResponseBodyParser {

        static func parse(_ data: Data, for request: InvalidHTTPRequestMock) throws -> Data {
            if let error = request.parseResponseBodyError {
                throw error
            } else {
                return Data()
            }
        }
    }
}
