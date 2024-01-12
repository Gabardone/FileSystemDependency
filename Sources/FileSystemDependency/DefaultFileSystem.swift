//
//  DefaultFileSystem.swift
//
//
//  Created by Óscar Morales Vivó on 6/21/23.
//

import Foundation

struct DefaultFileSystem {
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
            do {
                try data.write(to: fileURL, options: doNotOverwrite ? .withoutOverwriting : [])
            } catch let error as NSError
                where error.domain == NSCocoaErrorDomain && error.code == NSFileNoSuchFileError {
                // If we get the no such file error it means the directory path where we want the file doesn't exist.
                // We'll attempt to create it, then write. If either operation throws we 🤷🏽‍♂️
                try fileManager.createDirectory(
                    at: fileURL.deletingLastPathComponent(),
                    withIntermediateDirectories: true
                )
                try data.write(to: fileURL, options: [])
            }
        }.value
    }

    public func removeFileAt(fileURL: URL) async throws {
        try validate(fileURL)

        try await Task {
            do {
                try fileManager.removeItem(at: fileURL)
            } catch let error as NSError
                where error.domain == NSCocoaErrorDomain && error.code == NSFileNoSuchFileError {
                // File not found is fine. We'll let it go.
            }

        }.value
    }

    public func makeDirectoryAt(fileURL: URL) async throws {
        try validate(fileURL)

        try await Task {
            try fileManager.createDirectory(at: fileURL, withIntermediateDirectories: true)
        }.value
    }
}
