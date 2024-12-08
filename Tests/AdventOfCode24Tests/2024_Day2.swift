import AdventOfCode2024
import Testing

/*
--- Day 2: Red-Nosed Reports ---

Fortunately, the first location The Historians want to search isn't a long walk from the Chief Historian's office.

While the Red-Nosed Reindeer nuclear fusion/fission plant appears to contain no sign of the Chief Historian, the engineers there run up to you as soon as they see you. Apparently, they still talk about the time Rudolph was saved through molecular synthesis from a single electron.

They're quick to add that - since you're already here - they'd really appreciate your help analyzing some unusual data from the Red-Nosed reactor. You turn to check if The Historians are waiting for you, but they seem to have already divided into groups that are currently searching every corner of the facility. You offer to help with the unusual data.

The unusual data (your puzzle input) consists of many reports, one report per line. Each report is a list of numbers called levels that are separated by spaces. For example:

7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
This example data contains six reports each containing five levels.

The engineers are trying to figure out which reports are safe. The Red-Nosed reactor safety systems can only tolerate levels that are either gradually increasing or gradually decreasing. So, a report only counts as safe if both of the following are true:

The levels are either all increasing or all decreasing.
Any two adjacent levels differ by at least one and at most three.
In the example above, the reports can be found safe or unsafe by checking those rules:

7 6 4 2 1: Safe because the levels are all decreasing by 1 or 2.
1 2 7 8 9: Unsafe because 2 7 is an increase of 5.
9 7 6 2 1: Unsafe because 6 2 is a decrease of 4.
1 3 2 4 5: Unsafe because 1 3 is increasing but 3 2 is decreasing.
8 6 4 4 1: Unsafe because 4 4 is neither an increase or a decrease.
1 3 6 7 9: Safe because the levels are all increasing by 1, 2, or 3.
So, in this example, 2 reports are safe.

Analyze the unusual data from the engineers. How many reports are safe?
*/

fileprivate enum Direction {
  case increase
  case decrease
}

fileprivate func determineDirection(lhs: Int, rhs: Int) -> Direction {
  lhs < rhs ? .increase : .decrease
}

fileprivate func part1(_ file: String) throws -> [[Int]] {
    let contents = try readFile(file)
        .split(separator: "\n")
        .map { $0.split(separator: " ").compactMap { Int($0) } }

    var safeLevels = [[Int]]()
    outer: for level in contents {
        var currentValue = level.first!
        let startDirection: Direction = determineDirection(lhs: currentValue, rhs: level[1])
        let splitLevels = Array(level[1..<level.count])
        currentLevel: for (index, value) in splitLevels.enumerated() {
            let newDirection = determineDirection(lhs: currentValue, rhs: value)
            guard newDirection == startDirection else {
                break currentLevel
            }

            let distance = abs(currentValue - value)

            switch distance {
            case (1...3):
                if index == splitLevels.count - 1 {
                    safeLevels.append(level)
                }
            default:
                break currentLevel
            }

            currentValue = value
        }
    }

    return safeLevels
}

@Test("https://adventofcode.com/2024/day/2")
func AdventOfCode_2024_02_example_part1() throws {
    #expect(try part1("2024/02/example.txt").count == 2)
}

@Test
func AdventOfCode_2024_02_part1() throws {
    #expect(try part1("2024/02/input.txt").count == 246)
}

/*
 --- Part Two ---

 The engineers are surprised by the low number of safe reports until they realize they forgot to tell you about the Problem Dampener.

 The Problem Dampener is a reactor-mounted module that lets the reactor safety systems tolerate a single bad level in what would otherwise be a safe report. It's like the bad level never happened!

 Now, the same rules apply as before, except if removing a single level from an unsafe report would make it safe, the report instead counts as safe.

 More of the above example's reports are now safe:

 7 6 4 2 1: Safe without removing any level.
 1 2 7 8 9: Unsafe regardless of which level is removed.
 9 7 6 2 1: Unsafe regardless of which level is removed.
 1 3 2 4 5: Safe by removing the second level, 3.
 8 6 4 4 1: Safe by removing the third level, 4.
 1 3 6 7 9: Safe without removing any level.
 Thanks to the Problem Dampener, 4 reports are actually safe!

 Update your analysis by handling situations where the Problem Dampener can remove a single level from unsafe reports. How many reports are now safe?

 */

fileprivate func part2(_ file: String) throws -> (safeLevels: [[Int]], unsafeLevels: [[Int]]) {
    let contents = try readFile(file)
        .split(separator: "\n")
        .map { $0.split(separator: " ").compactMap { Int($0) } }

    var safeLevels = [[Int]]()
    var unsafeLevels = [[Int]]()

    outer: for level in contents {
        var currentValue = level.first!
        var currentDirection: Direction = determineDirection(lhs: currentValue, rhs: level[1])

        if currentValue == level[1] {
            currentDirection = determineDirection(lhs: level[1], rhs: level[2])
        }

        let splitLevels = Array(level[1..<level.count])
        var problemDampenerEnabled = true

        currentLevel: for (index, value) in splitLevels.enumerated() {
            let newDirection: Direction
            if level[0] == level[1] {
                problemDampenerEnabled = false
                newDirection = currentDirection
            } else {
                newDirection = determineDirection(lhs: currentValue, rhs: value)
            }

            let indexIsLast = index == splitLevels.count - 1
            let distance = abs(currentValue - value)

            if distance != 0 && newDirection != currentDirection {
                if problemDampenerEnabled {
                    problemDampenerEnabled = false
                    currentValue = value

                    currentDirection = determineDirection(lhs: value, rhs: splitLevels[min(index + 1, splitLevels.count - 1)])

                    if indexIsLast {
                        safeLevels.append(level)
                    }
                    continue
                } else {
                    unsafeLevels.append(level)
                    break currentLevel
                }
            }


            switch distance {
            case (1...3):
                if indexIsLast { safeLevels.append(level) }
                currentValue = value
            case (4...):
                switch (newDirection, distance) {
                case (.increase, 5):
                    unsafeLevels.append(level)
                    break currentLevel
                case (.decrease, 4):
                    unsafeLevels.append(level)
                    break currentLevel
                default:
                    guard problemDampenerEnabled else {
                        unsafeLevels.append(level)
                        break currentLevel
                    }

                    problemDampenerEnabled = false
                    currentValue = value
                    if indexIsLast { safeLevels.append(level) }
                }
            case 0:
                guard problemDampenerEnabled else {
                    unsafeLevels.append(level)
                    break currentLevel
                }

                problemDampenerEnabled = false
                currentValue = value
                if indexIsLast { safeLevels.append(level) }
            default:
                unsafeLevels.append(level)
                break currentLevel
            }
        }
    }

    return (safeLevels: safeLevels, unsafeLevels: unsafeLevels)
}

@Test func AdventOfCode_2024_02_example_part2() throws {
    let (safeLevels, unsafeLevels) = try part2("2024/02/example.txt")

    #expect(safeLevels == [
        [7, 6, 4, 2, 1],
        [1, 3, 2, 4, 5],
        [8, 6, 4, 4, 1],
        [1, 3, 6, 7, 9]
    ])

    #expect(unsafeLevels == [
        [1, 2, 7, 8, 9],
        [9, 7, 6, 2, 1],
    ])
}

@Test func AdventOfCode_2024_02_part2() throws {
    let (safeLevels, unsafeLevels) = try part2("2024/02/input.txt")
    #expect(safeLevels.count == 318)
    #expect(unsafeLevels.count == 682)
}
