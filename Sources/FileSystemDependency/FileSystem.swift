//
//  FileSystem.swift
//
//
//  Created by Óscar Morales Vivó on 6/20/23.
//

import Foundation
@_exported import GlobalDependencies

/**
 General errors thrown by `FileSystem` implementations.

 Most of the time errors thrown will be those that `FileManager` or the data read/write operations throw. But we can
 perform some additional validation and post other exceptions when the system APIs don't or it's more useful to do so.
 */
public enum FileSystemError: Error {
    /**
     Implementations of `FileSystem` should validate that their `fileURL` parameters actually are file URLs. If they are
     not this error will be thrown, with an associated value of the offending URL.
     */
    case notAFileURL(URL)
}

/**
 A façade for access to the local file system.

 The file system protocol offers a cover for `FileManager` and its methods assume the presence of a local hierarchical
 file system that the calling logic has access to (or at least parts of it).

 As a gesture towards modern API ergonomics the façade uses Swift concurrency to reflect the fact that access to the
 file system ought to be an asynchronous operation as even in the best circumsntances it happens a much slower pace than
 regular code execution.

 The reading API also operates on `Task` values instead of directly performing the operations requested. This adds very
 little friction to obtaining the results and helps debounce requests for the same data. Writing operations are
 performed directly as it's not practical to debounce them at the file system access layer.
 */
@Dependency()
public protocol FileSystem {
    /**
     Returns the data for a file at the given file URL.

     The method will `throw` if the URL parameter is invalid or any issue prevents accessing the data, including if
     there is no actual data at the location.

     The exceptions thrown should be the same ones that `FileManager` would.
     - Parameter fileURL: A file URL pointing to the file containing the data requested. The method will throw if it is
     not a file URL.
     - Returns: A task that returns the data in the file, or throws an error if there was none or it couldn't be
     accessed.
     */
    func dataFor(fileURL: URL) async throws -> Data

    /**
     Writes the given data to a file at the given file URL.

     The method will overwrite any existing data at the location, no questions asked. It will also create any needed
     directories along the path if they don't already exist.

     The method will `throw` if the URL parameter is invalid or if the write operation cannot be completed for any
     reason.

     The exceptions thrown should be the same ones that `FileManager` would.
     - Parameter data: The data to write. The method will throw if it is not a file URL.
     - Parameter fileURL: A file URL
     - Parameter doNotOverwrite: If true, the operation will `throw` if there is a file already exists at `fileURL`.
     */
    func write(data: Data, fileURL: URL, doNotOverwrite: Bool) async throws

    /**
     Removes the file at the given file URL.

     The method will attempt to remove the file at `fileURL` if there is no file there, it will just do nothing and
     return. If it fails to remove an existing file or otherwise cannot even determine if one exists it will `throw`.
     - Parameter fileURL: A file URL pointing to the file we want no longer to exist.
     */
    func removeFileAt(fileURL: URL) async throws

    /**
     Creates a directory at the given file URL.

     The method will attempt to create a directory at the given URL. It will also create any intermediate directories
     needed if they don't already exist.

     If a directory already exists at `fileURL`, the method will return successfully.
     - Parameter fileURL: A URL pointing to where we want a directory to exist.
     */
    func makeDirectoryAt(fileURL: URL) async throws
}

/**
 Necessary adoption of `FileSystem.Dependency` by `GlobalDependencies`
 */
extension GlobalDependencies: FileSystem.Dependency {
    public #GlobalDependency(type: FileSystem)
}

/**
 Default value builder. Kept `private`
 */
private struct DefaultFileSystemValueFactory: DefaultDependencyValueFactory {
    static func makeDefaultValue() -> DefaultFileSystem {
        return DefaultFileSystem()
    }
}
