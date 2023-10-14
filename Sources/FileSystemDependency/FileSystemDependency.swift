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

public struct FileSystemDependencyKey: DependencyKey {
    public static let defaultValue: any FileSystem = DefaultFileSystem()
}

extension GlobalDependencies: FileSystemDependency {
    public var fileSystem: any FileSystem {
        resolveDependencyFor(key: FileSystemDependencyKey.self)
    }
}
