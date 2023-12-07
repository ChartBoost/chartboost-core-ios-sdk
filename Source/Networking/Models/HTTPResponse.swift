// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.


/// A HTTP response.
struct HTTPResponse<Body> {

    /// The response HTTP status code.
    let statusCode: HTTPStatusCode?

    /// The response HTTP headers.
    let headers: [AnyHashable: Any]?

    /// A result containing the decoded response body, if any, or an error.
    let result: Result<Body?, Error>
}
