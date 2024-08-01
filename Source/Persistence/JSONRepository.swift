// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import Foundation

/// A repository that provides access to and persists Codable values.
protocol JSONRepository {
    /// Returns the latest value for a given name.
    /// - parameter type: The type to decode.
    /// - parameter name: The string that identifies the value.
    /// - returns: The decoded value. An error is thrown if a value could not be retrieved.
    func read<Value: Decodable>(_ type: Value.Type, name: String) throws -> Value

    /// Persists a new value for a given name.
    /// - parameter value: The value to persist.
    /// - parameter name: The string that identifies the value.
    ///
    /// An error is thrown if the value could not be persisted.
    func write<Value: Codable>(_ value: Value, name: String) throws

    /// Removes a persisted value for a given name.
    /// - parameter name: The string that identifies the value.
    ///
    /// An error is thrown if the value could not be removed.
    func removeValue(name: String) throws

    /// Indicates if a value for a given name is already persisted.
    /// - parameter name: The string that identifies the value.
    /// - returns: A boolean indicating wether the value exists or not.
    func valueExists(name: String) -> Bool
}

/// Core's concrete implementation of ``JSONRepository``.
struct ChartboostCoreJSONRepository: JSONRepository {
    @Injected(\.fileStorage) private  var fileStorage

    let directoryLocation: FileManager.SearchPathDirectory
    let directoryName: String

    func read<Value: Decodable>(_ type: Value.Type, name: String) throws -> Value {
        let url = try url(for: name)
        let data = try fileStorage.readData(at: url)
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }

    func write<Value: Codable>(_ value: Value, name: String) throws {
        let url = try url(for: name)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(value)
        try fileStorage.write(data, to: url)
    }

    func removeValue(name: String) throws {
        let url = try url(for: name)
        try fileStorage.removeFile(at: url)
    }

    func valueExists(name: String) -> Bool {
        guard let url = try? url(for: name) else {
            return false
        }
        return fileStorage.fileExists(at: url)
    }

    private func url(for valueName: String) throws -> URL {
        try fileStorage.systemDirectoryURL(directoryLocation)
            .appendingPathComponent(directoryName)
            .appendingPathComponent(valueName + ".json")
    }
}
