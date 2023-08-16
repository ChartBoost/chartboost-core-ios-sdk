// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A HTTP request with a Data body and Data response.
protocol HTTPDataRequest:
    HTTPRequest
where Body == Data,
      ResponseBody == Data,
      RequestBuilder == DataURLRequestBuilder<Self>,
      ResponseBodyParser == DataURLResponseBodyParser<Self>
{
}
