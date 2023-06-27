//
//  ComposableFileSystem.swift
//
//
//  Created by Óscar Morales Vivó on 6/21/23.
//

import Foundation

/**
 Composable implementation of FileSystem.

 Mostly useful as a mock for tests, but can also be used to quickly build an implementation of `FileSystem`
 Javascript-style.
  */
public struct ComposableFileSystem {
    /**
     Default initializer. Sets all the overrides.
     */
    public init(
        dataForOverride: @escaping (URL) async throws -> Data,
        writeDataOverride: @escaping (Data, URL, Bool) async throws -> Void,
        removeFileAtOverride: @escaping (URL) async throws -> Void,
        makeDirectoryAtOverride: @escaping (URL) async throws -> Void
    ) {
        self.dataForOverride = dataForOverride
        self.writeDataOverride = writeDataOverride
        self.removeFileAtOverride = removeFileAtOverride
        self.makeDirectoryAtOverride = makeDirectoryAtOverride
    }

    public var dataForOverride: (URL) async throws -> Data

    public var writeDataOverride: (Data, URL, Bool) async throws -> Void

    public var removeFileAtOverride: (URL) async throws -> Void

    public var makeDirectoryAtOverride: (URL) async throws -> Void
}

extension ComposableFileSystem: FileSystem {
    public func dataFor(fileURL: URL) async throws -> Data {
        try await dataForOverride(fileURL)
    }

    public func write(data: Data, fileURL: URL, doNotOverwrite: Bool) async throws {
        try await writeDataOverride(data, fileURL, doNotOverwrite)
    }

    public func removeFileAt(fileURL: URL) async throws {
        try await removeFileAtOverride(fileURL)
    }

    public func makeDirectoryAt(fileURL: URL) async throws {
        try await makeDirectoryAtOverride(fileURL)
    }
}
