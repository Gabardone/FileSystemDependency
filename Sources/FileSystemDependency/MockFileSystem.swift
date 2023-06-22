//
//  MockFileSystem.swift
//
//
//  Created by Óscar Morales Vivó on 6/21/23.
//

import Foundation

/**
 Simple mock for file system data access. Use it in tests as an override of `FileSystemDependency`.

 This should go into its own package but that causes issues where the compiler gets confused in test targets and
 dependency overrides fail to work.
  */
public struct MockFileSystem {
    /**
     Default initializer. Set the overrides after initialization and before dependency override happens.
     */
    public init() {}

    /**
     Throw this when the error is due to the mock setup not matching the test behavior.
     */
    public enum MockError: Error {
        case unexpectedCall(String)
    }

    var dataForOverride: ((URL) async throws -> Data)?

    var writeDataOverride: ((Data, URL, Bool) async throws -> Void)?

    var removeFileAtOverride: ((URL) async throws -> Void)?

    var makeDirectoryAtOverride: ((URL) async throws -> Void)?

    var temporaryDirectoryOverride: URL?
}

extension MockFileSystem: FileSystem {
    public func dataFor(fileURL: URL) async throws -> Data {
        guard let dataForOverride else {
            throw MockError.unexpectedCall(#function)
        }

        return try await dataForOverride(fileURL)
    }

    public func write(data: Data, fileURL: URL, doNotOverwrite: Bool) async throws {
        guard let writeDataOverride else {
            throw MockError.unexpectedCall(#function)
        }

        try await writeDataOverride(data, fileURL, doNotOverwrite)
    }

    public func removeFileAt(fileURL: URL) async throws {
        guard let removeFileAtOverride else {
            throw MockError.unexpectedCall(#function)
        }

        try await removeFileAtOverride(fileURL)
    }

    public func makeDirectoryAt(fileURL: URL) async throws {
        guard let makeDirectoryAtOverride else {
            throw MockError.unexpectedCall(#function)
        }

        try await makeDirectoryAtOverride(fileURL)
    }

    public var temporaryDirectory: URL {
        guard let temporaryDirectoryOverride else {
            // We'll want to convert this to `XCTFail` once we have a mock builder macro.
            preconditionFailure("temporaryDirectory not set")
        }

        return temporaryDirectoryOverride
    }
}
