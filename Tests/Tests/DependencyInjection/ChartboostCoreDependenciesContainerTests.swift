// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK
import XCTest

class ChartboostCoreDependenciesContainerTests: ChartboostCoreTestCase {
    /// Validates that the dependencies container can be initialized without recursive dependencies between
    /// objects that could lead to a crash.
    func testInit() {
        _ = ChartboostCoreDependenciesContainer()
        // just checking that we didn't crash
    }
}
