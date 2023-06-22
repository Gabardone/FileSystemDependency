//
//  DefaultFileSystem.swift
//
//
//  Created by Óscar Morales Vivó on 6/21/23.
//

import Foundation

public struct DefaultFileSystem {
    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    public let fileManager: FileManager
}

extension DefaultFileSystem: FileSystem {
    private func validate(_ fileURL: URL) throws {
        guard fileURL.isFileURL else {
            throw FileSystemError.notAFileURL(fileURL)
        }
    }

    public func dataFor(fileURL: URL) async throws -> Data {
        try validate(fileURL)

        return try await Task {
            try Data(contentsOf: fileURL)
        }.value
    }

    public func write(data: Data, fileURL: URL, doNotOverwrite: Bool) async throws {
        try validate(fileURL)

        try await Task {
            try data.write(to: fileURL, options: doNotOverwrite ? .withoutOverwriting : [])
        }.value
    }

    public func removeFileAt(fileURL: URL) async throws {
        try validate(fileURL)

        try await Task {
            try fileManager.removeItem(at: fileURL)
        }.value
    }

    public func makeDirectoryAt(fileURL: URL) async throws {
        try validate(fileURL)

        try await Task {
            try fileManager.createDirectory(at: fileURL, withIntermediateDirectories: true)
        }.value
    }

    public var temporaryDirectory: URL {
        fileManager.temporaryDirectory
    }
}
