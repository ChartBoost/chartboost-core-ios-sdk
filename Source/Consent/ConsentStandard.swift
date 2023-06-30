// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

@objc(ChartboostCoreConsentStandard)
@objcMembers
public final class ConsentStandard: NSObject, ExpressibleByStringLiteral {

    public let gdpr: ConsentStandard = "gdpr"
    public let ccpa: ConsentStandard = "ccpa"
    public let tcf: ConsentStandard = "IABTCF_TCString"
    public let usp: ConsentStandard = "IABUSPrivacy_String"
    public let gpp: ConsentStandard = "IABGPP_HDR_GppString"

    private let value: String

    private override init() {
        fatalError()
    }

    public required init(stringLiteral value: StringLiteralType) {
        self.value = value
    }
}
