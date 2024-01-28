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
        .visionOS(.v1),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "FileSystemDependency",
            targets: ["FileSystemDependency"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Gabardone/GlobalDependencies", .upToNextMajor(from: "2.0.1")),
        // Depend on the swift documentation plugin to produce web-ready docs.
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0")
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
