// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

@testable import ChartboostCoreSDK

final class FileStorageMock: FileStorage {
    // MARK: - Call Counts and Return Values

    var systemDirectoryURLReturnValue: Any? = try? FileManager.default.url(
        for: .cachesDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: false
    )

    var fileExistsReturnValue = true
    var fileExistsURLLastValue: URL?

    var removeFileCallCount = 0
    var removeFileURLLastValue: URL?
    var removeFileError: Error?

    var writeCallCount = 0
    var writeDataLastValue: Data?
    var writeURLLastValue: URL?
    var writeError: Error?

    var readDataCallCount = 0
    var readDataURLLastValue: URL?
    var readDataReturnValue: Any?

    var directoryExistsReturnValue = true

    var createDirectoryCallCount = 0
    var createDirectoryURLLastValue: URL?
    var createDirectoryError: Error?

    var removeDirectoryCallCount = 0
    var removeDirectoryURLLastValue: URL?
    var removeDirectoryError: Error?

    // MARK: - FileStorage

    // swiftlint:disable force_cast
    func systemDirectoryURL(_ type: FileManager.SearchPathDirectory) throws -> URL {
        if let error = systemDirectoryURLReturnValue as? Error {
            throw error
        } else {
            return systemDirectoryURLReturnValue as! URL
        }
    }
    // swiftlint:enable force_cast

    func fileExists(at url: URL) -> Bool {
        fileExistsURLLastValue = url
        return fileExistsReturnValue
    }

    func removeFile(at url: URL) throws {
        removeFileCallCount += 1
        removeFileURLLastValue = url
        if let error = removeFileError {
            throw error
        }
    }

    func write(_ data: Data, to url: URL) throws {
        writeCallCount += 1
        writeDataLastValue = data
        writeURLLastValue = url
        if let error = writeError {
            throw error
        }
    }

    // swiftlint:disable force_cast
    func readData(at url: URL) throws -> Data {
        readDataCallCount += 1
        readDataURLLastValue = url
        if let error = readDataReturnValue as? Error {
            throw error
        } else {
            return readDataReturnValue as! Data
        }
    }
    // swiftlint:enable force_cast

    func directoryExists(at url: URL) -> Bool {
        directoryExistsReturnValue
    }

    func createDirectory(at url: URL) throws {
        createDirectoryCallCount += 1
        createDirectoryURLLastValue = url
        if let error = createDirectoryError {
            throw error
        }
    }

    func removeDirectory(at url: URL) throws {
        removeDirectoryCallCount += 1
        removeDirectoryURLLastValue = url
        if let error = removeDirectoryError {
            throw error
        }
    }
}
