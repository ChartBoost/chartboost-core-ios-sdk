// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A parser that knows how to process the Data obtained from a URL response into a request's response body type.
/// - note: The proessing this parser does is completely pass-through, but we still need it so HTTPRequest types
/// can use it as their associated ResponseBodyParser type to indicate how to parse their response (in this case,
/// just pass the original Data unaltered).
struct DataURLResponseBodyParser<Request: HTTPRequest>: URLResponseBodyParser where Request.ResponseBody == Data {
    static func parse(_ data: Data, for request: Request) throws -> Request.ResponseBody {
        data
    }
}
