// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class LogHandlerMock: LogHandler {

    // MARK: - Call Counts and Return Values

    var handleCallCount = 0
    var handleEntryLastValue: LogEntry?

    // MARK: - LogHandler

    func handle(_ entry: LogEntry) {
        handleCallCount += 1
        handleEntryLastValue = entry
    }
}
