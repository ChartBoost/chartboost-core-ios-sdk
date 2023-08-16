// Copyright 2022-2023 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

import XCTest
@testable import ChartboostCoreSDK

class ChartboostCoreJSONRepositoryTests: ChartboostCoreTestCase {

    lazy var repository = ChartboostCoreJSONRepository(
        directoryLocation: directoryLocation,
        directoryName: directoryName
    )
    let directoryLocation: FileManager.SearchPathDirectory = .cachesDirectory
    let directoryName = "DirName"

    /// Validates that a call to `read()` returns a decoded value from the file.
    func testReadValidJSON() throws {
        let model = CodableModel()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(model)
        mocks.fileStorage.readDataReturnValue = data

        let value = try repository.read(CodableModel.self, name: "someName")

        XCTAssertEqual(value, model)
        XCTAssertEqual(
            mocks.fileStorage.readDataURLLastValue,
            (mocks.fileStorage.systemDirectoryURLReturnValue as? URL)?
                .appendingPathComponent(directoryName)
                .appendingPathComponent("someName.json")
        )
    }

    /// Validates that a call to `read()` throws an error if a file with the provided name does
    /// not exist in the repository directory.
    func testReadNonExistingJSON() throws {
        let expectedError = NSError(domain: "no file", code: 33)
        mocks.fileStorage.readDataReturnValue = expectedError

        do {
            _ = try repository.read(CodableModel.self, name: "someName")
            XCTFail("Should have thrown")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }

    /// Validates that a call to `read()` throws an error if the file cannot be decoded into
    /// the expected type.
    func testReadInvalidJSON() throws {
        mocks.fileStorage.readDataReturnValue = "not an encoded CodableModel".data(using: .utf8)

        do {
            _ = try repository.read(CodableModel.self, name: "someName")
            XCTFail("Should have thrown")
        } catch {
        }
    }

    /// Validates that a call to `write()` succeeds if the file storage succeeds in persisting the file.
    func testWriteJSONWithSuccess() throws {
        let model = CodableModel()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(model)
        mocks.fileStorage.writeError = nil

        try repository.write(model, name: "someName")

        XCTAssertEqual(mocks.fileStorage.writeCallCount, 1)
        XCTAssertEqual(mocks.fileStorage.writeDataLastValue, data)
        XCTAssertEqual(
            mocks.fileStorage.writeURLLastValue,
            (mocks.fileStorage.systemDirectoryURLReturnValue as? URL)?
                .appendingPathComponent(directoryName)
                .appendingPathComponent("someName.json")
        )
    }

    /// Validates that a call to `write()` throws an error if the file storage fails to persist the file.
    func testWriteJSONWithFailure() throws {
        let model = CodableModel()
        let expectedError = NSError(domain: "failed to write", code: 33)
        mocks.fileStorage.writeError = expectedError

        do {
            _ = try repository.write(model, name: "someName")
            XCTFail("Should have thrown")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }

    /// Validates that a call to `removeValue()` succeeds if the file storage succeeds in removing the file.
    func testRemoveValueWithSuccess() throws {
        mocks.fileStorage.removeFileError = nil

        try repository.removeValue(name: "someName")

        XCTAssertEqual(mocks.fileStorage.removeFileCallCount, 1)
        XCTAssertEqual(
            mocks.fileStorage.removeFileURLLastValue,
            (mocks.fileStorage.systemDirectoryURLReturnValue as? URL)?
                .appendingPathComponent(directoryName)
                .appendingPathComponent("someName.json")
        )
    }

    /// Validates that a call to `removeValue()` throws an error if the file storage fails to remove the file.
    func testRemoveValueWithFailure() throws {
        let expectedError = NSError(domain: "failed to remove", code: 33)
        mocks.fileStorage.removeFileError = expectedError

        do {
            try repository.removeValue(name: "someName")
            XCTFail("Should have thrown")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }

    /// Validates that a call to `valueExists()` returns true if the file exists.
    func testValueExists() throws {
        mocks.fileStorage.fileExistsReturnValue = true

        let value = repository.valueExists(name: "someName")

        XCTAssertTrue(value)
        XCTAssertEqual(
            mocks.fileStorage.fileExistsURLLastValue,
            (mocks.fileStorage.systemDirectoryURLReturnValue as? URL)?
                .appendingPathComponent(directoryName)
                .appendingPathComponent("someName.json")
        )
    }

    /// Validates that a call to `valueExists()` returns false if the file does not exist.
    func testValueDoesNotExist() throws {
        mocks.fileStorage.fileExistsReturnValue = false

        let value = repository.valueExists(name: "someName")

        XCTAssertFalse(value)
    }
}

private struct CodableModel: Codable, Equatable {
    let field1: String
    let field2: String
    let field3: Int

    init(field1: String = "some value 1", field2: String = "some value 2", field3: Int = 42) {
        self.field1 = field1
        self.field2 = field2
        self.field3 = field3
    }
}
