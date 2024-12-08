import Foundation

public extension String {
    subscript(index: Int) -> Character? {
        guard index >= 0 && index < self.count else { return nil }
        let stringIndex = self.index(self.startIndex, offsetBy: index)
        return self[stringIndex]
    }
}
