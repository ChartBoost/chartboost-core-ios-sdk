// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objc(ChartboostCoreConsentValue)
@objcMembers
public final class ConsentValue: NSObject, ExpressibleByStringLiteral {

    public let granted: ConsentValue = "granted"
    public let denied: ConsentValue = "denied"
    public let doesNotApply: ConsentValue = "does_not_apply"

    private let value: String

    private override init() {
        fatalError()
    }

    public required init(stringLiteral value: StringLiteralType) {
        self.value = value
    }
}
