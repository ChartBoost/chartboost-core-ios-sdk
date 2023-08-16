// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class NetworkManagerMock: NetworkManager {

    var sendCallCount = 0
    var sendRequestLastValue: (any HTTPRequest)?
    var sendCompletionLastValue: Any?

    func send<Request: HTTPRequest>(
        _ request: Request,
        completion: @escaping (HTTPResponse<Request.ResponseBody>) -> Void
    ) {
        sendCallCount += 1
        sendRequestLastValue = request
        sendCompletionLastValue = completion
    }
}
