// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

/// A basic HTTP Data request.
struct HTTPDataRequestMock: HTTPDataRequest {
    // swiftlint:disable force_unwrapping
    let url = URL(string: "www.chartboost.com")!
    // swiftlint:enable force_unwrapping

    let method = HTTPMethod.get
    let headers: HTTPHeaders = ["some header": "value1", "another header": "value2"]
    let body = "some data".data(using: .utf8)
}
