// Copyright 2023-2025 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class JSONRepositoryMock: JSONRepository {
    // MARK: - Call Counts and Return Values

    var readCallCount = 0
    var readTypeLastValue: Any.Type?
    var readNameLastValue: String?
    var readReturnValue: Any? = NSError(domain: "", code: 0)

    var writeCallCount = 0
    var writeValueLastValue: Any?
    var writeNameLastValue: String?

    var removeValueCallCount = 0
    var removeValueNameLastValue: String?
    var removeValueError: Error?

    var valueExistsCallCount = 0
    var valueExistsNameLastValue: String?
    var valueExistsReturnValue = true

    // MARK: - JSONRepository

    // swiftlint:disable force_cast
    func read<Value: Decodable>(_ type: Value.Type, name: String) throws -> Value {
        readCallCount += 1
        readTypeLastValue = type
        readNameLastValue = name
        if let error = readReturnValue as? Error {
            throw error
        } else {
            return readReturnValue as! Value
        }
    }
    // swiftlint:enable force_cast

    func write<Value: Codable>(_ value: Value, name: String) throws {
        writeCallCount += 1
        writeValueLastValue = value
        writeNameLastValue = name
    }

    func removeValue(name: String) throws {
        removeValueCallCount += 1
        removeValueNameLastValue = name
        if let error = removeValueError {
            throw error
        }
    }

    func valueExists(name: String) -> Bool {
        valueExistsCallCount += 1
        valueExistsNameLastValue = name
        return valueExistsReturnValue
    }
}
