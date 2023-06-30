// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objcMembers
public class ChartboostCoreResult: NSObject {
    public let startDate: Date
    public let endDate: Date
    public var duration: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }
    public let error: Error?

    internal init(startDate: Date, endDate: Date, error: Error?) {
        self.startDate = startDate
        self.endDate = endDate
        self.error = error
    }
}
