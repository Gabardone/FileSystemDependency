// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FileSystemDependency",
    platforms: [
        // Minimum deployment version bound by `async/await` support.
        .iOS(.v13),
        .macCatalyst(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "FileSystemDependency",
            targets: ["FileSystemDependency"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Gabardone/GlobalDependencies", .branch("MacroSupport"))
    ],
    targets: [
        .target(
            name: "FileSystemDependency",
            dependencies: ["GlobalDependencies"]
        ),
        .testTarget(
            name: "FileSystemDependencyTests",
            dependencies: ["FileSystemDependency"]
        )
    ]
)
