import Foundation

func readFile(_ file: String) throws -> String {
    try String(contentsOfFile: inputPath.appending(path: file).path(), encoding: .utf8)
}
