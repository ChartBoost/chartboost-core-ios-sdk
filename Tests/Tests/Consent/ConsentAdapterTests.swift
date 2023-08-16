// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ConsentAdapterTests: XCTestCase {

    /// Validates that the default implementation for `ConsentAdapter.log(_:level:)` exists and does not crash.
    func testLog() {
        // The method just prints a string to the console, so there's not much for us to check, just making
        // sure that this does not crash.
        ConsentAdapterMock().log("some message", level: .info)
    }
}
