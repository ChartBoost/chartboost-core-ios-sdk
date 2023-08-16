// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A base result class for Chartboost Core operations.
@objc(CBCResult)
@objcMembers
public class ChartboostCoreResult: NSObject {

    /// The start date of the operation.
    public let startDate: Date

    /// The end date of the operation.
    public let endDate: Date

    /// The duration of the operation.
    public var duration: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }

    /// The error in case the operation failed, or `nil` if the operation succeeded.
    public let error: Error?

    /// Initializes a result object with the provided information.
    internal init(startDate: Date, endDate: Date, error: Error?) {
        self.startDate = startDate
        self.endDate = endDate
        self.error = error
    }

    // Make NSObject init private to prevent users from instantiating this class.
    override private init() {
        self.startDate = Date()
        self.endDate = Date()
        self.error = nil
    }
}
