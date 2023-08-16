// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class DataURLRequestBuilderTests: ChartboostCoreTestCase {

    /// Validates that a call to `makeURLRequest()` returns a URL request with proper values obtained
    /// from the request object passed.
    func testMakeURLRequest() throws {
        let request = HTTPDataRequestMock()
        let urlRequest = try DataURLRequestBuilder<HTTPDataRequestMock>.makeURLRequest(from: request)
        XCTAssertEqual(urlRequest.url, request.url)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, request.headers)
        XCTAssertEqual(urlRequest.httpMethod, request.method.description)
        XCTAssertEqual(urlRequest.httpBody, request.body)
    }
}
