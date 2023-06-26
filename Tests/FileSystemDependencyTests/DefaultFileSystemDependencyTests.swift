@testable import FileSystemDependency
import XCTest

final class DefaultFileSystemDependencyTests: XCTestCase {
    // Tests that intermediate directories are created in `DefaultFileSystem` write operations
    func testWriteFileCreatesIntermediateDirectories() async throws {
        let fileManager = FileManager.default
        let fileSystem = DefaultFileSystem(fileManager: fileManager)

        // A UUID as a directory name should be safe enough for testing purposes.
        let destinationURL = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
            .appendingPathComponent("Test.data", isDirectory: false)

        // Test will fail if the operation throws.
        try await fileSystem.write(data: Data(), fileURL: destinationURL, doNotOverwrite: false)
    }
}
