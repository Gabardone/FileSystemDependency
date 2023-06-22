//
//  FileSystemDependency.swift
//
//
//  Created by Óscar Morales Vivó on 6/21/23.
//

import Foundation
@_exported import GlobalDependencies

/**
 A protocol to adopt for dependencies that require access to the local file system.
 */
public protocol FileSystemDependency: Dependencies {
    var fileSystem: any FileSystem { get }
}

extension GlobalDependencies: FileSystemDependency {
    private static let defaultFileSystem: any FileSystem = DefaultFileSystem()

    public var fileSystem: any FileSystem {
        resolveDependency(forKeyPath: \.fileSystem, defaultImplementation: Self.defaultFileSystem)
    }
}
