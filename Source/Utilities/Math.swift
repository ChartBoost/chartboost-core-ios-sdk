// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A namespace for math formulas.
enum Math {
    /// The time interval to wait before doing a retry for an operation like initialization.
    /// E.g., for base = 1, max = 30, and retryNumber increasing from 1 to 8, values are: 1, 2, 4, 8, 16, 30, 30, 30
    static func retryDelayInterval(retryNumber: Int, base: TimeInterval, limit: TimeInterval) -> TimeInterval {
        min(base * pow(2, Double(retryNumber - 1)), limit)
    }
}
