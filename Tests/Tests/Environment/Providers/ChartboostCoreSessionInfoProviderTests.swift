// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ChartboostCoreSessionInfoProviderTests: ChartboostCoreTestCase {
    let provider = ChartboostCoreSessionInfoProvider()

    /// Validates that initially there is no session.
    func testInitialValues() {
        XCTAssertNil(provider.session)
    }

    /// Validates that calling `reset()` for the first time generates a new session.
    func testFirstReset() {
        provider.reset()
        XCTAssertNotNil(provider.session)
    }

    /// Validates that calling `reset()` for the second time replaces the previous session with a new one.
    func testSecondReset() {
        provider.reset()
        let firstSession = provider.session
        provider.reset()
        XCTAssertNotNil(provider.session)
        XCTAssertNotEqual(provider.session?.identifier, firstSession?.identifier)
    }
}
