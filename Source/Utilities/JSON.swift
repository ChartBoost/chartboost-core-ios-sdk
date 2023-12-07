// Copyright 2023-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A Codable representation for a JSON object.
/// Useful as part of another Codable object, where a generic `[String: Any]` property cannot be used since such a type cannot conform to Codable.
/// - parameter T: The primitive value type expected to match the JSON structure.
struct JSON<T>: Codable, Equatable {

    /// The native primitive value represented by this JSON model.
    let value: T

    init(value: T) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        // Decode the JSON data
        let container = try decoder.singleValueContainer()
        let jsonValue = try container.decode(JSONValue.self)

        // Unwrap the primitive value as a the expected type
        guard let value = jsonValue.primitiveValue as? T else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath, debugDescription: "JSON value is not the expected type \(T.self)")
            )
        }

        // Set the value
        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let jsonValue = try JSONValue(primitiveValue: value)
        try container.encode(jsonValue)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        do {
            return try JSONValue(primitiveValue: lhs.value) == JSONValue(primitiveValue: rhs.value)
        } catch {
            return false
        }
    }
}

/// A Codable JSON value.
private enum JSONValue: Codable, Equatable {
    case object([String: JSONValue])
    case array([JSONValue])
    case string(String)
    case bool(Bool)
    case integer(Int)
    case double(Double)
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let object = try? container.decode([String: JSONValue].self) {
            self = .object(object)
        } else if let array = try? container.decode([JSONValue].self) {
            self = .array(array)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let integer = try? container.decode(Int.self) {
            self = .integer(integer)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath, debugDescription: "Invalid JSON value")
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .object(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        case .integer(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }

    /// The primitive value wrapped by the JSON value.
    var primitiveValue: Any? {
        switch self {
        case .object(let value): return value.mapValues(\.primitiveValue)
        case .array(let value): return value.map(\.primitiveValue)
        case .string(let value): return value
        case .bool(let value): return value
        case .integer(let value): return value
        case .double(let value): return value
        case .null: return nil
        }
    }

    init(primitiveValue: Any?) throws {
        if let value = primitiveValue as? [String: Any] {
            self = .object(try value.mapValues(JSONValue.init(primitiveValue:)))
        } else if let value = primitiveValue as? [Any] {
            self = .array(try value.map(JSONValue.init(primitiveValue:)))
        } else if let value = primitiveValue as? String {
            self = .string(value)
        } else if let value = primitiveValue as? Bool {
            self = .bool(value)
        } else if let value = primitiveValue as? Int {
            self = .integer(value)
        } else if let value = primitiveValue as? Double {
            self = .double(value)
        } else if let value = primitiveValue {
            throw EncodingError.invalidValue(value, .init(codingPath: [], debugDescription: "Invalid primitive value is a non-JSON value."))
        } else {
            self = .null
        }
    }
}
