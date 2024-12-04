import Foundation

let rootPath = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()

let inputPath = rootPath.appendingPathComponent("Input")
