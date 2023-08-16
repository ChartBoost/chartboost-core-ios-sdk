// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class WeakWrapperTests: ChartboostCoreTestCase {

    /// Validates that a weak wrapper does not hold a strong reference to its value.
    func testWeakWrapperDoesNotRetainItsValue() {
        var wrapper: WeakWrapper<NSObject>?

        autoreleasepool {
            let object = NSObject()
            wrapper = WeakWrapper(object)

            XCTAssertNotNil(wrapper?.value)
        }

        XCTAssertNil(wrapper?.value)
    }
}
