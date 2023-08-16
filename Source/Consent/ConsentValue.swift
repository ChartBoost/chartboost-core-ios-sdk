// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A model representing a consent value for a specific standard, like IAB's TCF or USP strings.
/// It is used by ``ConsentManagementPlatform`` to provide detailed consent status.
@objc(CBCConsentValue)
@objcMembers
public final class ConsentValue: NSObject, ExpressibleByStringLiteral {

    /// Indicates the user denied consent.
    public static let denied: ConsentValue = "denied"

    /// Indicates the standard does not apply.
    public static let doesNotApply: ConsentValue = "does_not_apply"

    /// Indicates the user granted consent.
    public static let granted: ConsentValue = "granted"

    /// The string value.
    public let value: String

    private override init() {
        fatalError()
    }

    /// Creates a custom value with an arbitrary string value.
    public required init(stringLiteral value: StringLiteralType) {
        self.value = value
    }

    public override var description: String {
        value
    }

    // Compare the backing `value` instead of the object itself. Without this, custom `ConsentValue`
    // declared as a `static var` always fails the equality test because a new instance is generated
    // each time.
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else {
            return false
        }

        return value == other.value
    }

    public override var hash: Int {
        value.hash
    }
}

extension ConsentValue: Codable {
    public convenience init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self.init(stringLiteral: value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

/// Obj-C NSDictionary keys must conform to NSCopying.
extension ConsentValue: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        ConsentValue(stringLiteral: value)
    }
}
