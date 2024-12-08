import AdventOfCode2024
import Foundation
import Testing

/*
 --- Day 4: Ceres Search ---

 "Looks like the Chief's not here. Next!" One of The Historians pulls out a device and pushes the only button on it. After a brief flash, you recognize the interior of the Ceres monitoring station!

 As the search for the Chief continues, a small Elf who lives on the station tugs on your shirt; she'd like to know if you could help her with her word search (your puzzle input). She only has to find one word: XMAS.

 This word search allows words to be horizontal, vertical, diagonal, written backwards, or even overlapping other words. It's a little unusual, though, as you don't merely need to find one instance of XMAS - you need to find all of them. Here are a few ways XMAS might appear, where irrelevant characters have been replaced with .:

 ..X...
 .SAMX.
 .A..A.
 XMAS.S
 .X....
 The actual word search will be full of letters instead. For example:

 MMMSXXMASM
 MSAMXMSMSA
 AMXSXMAAMM
 MSAMASMSMX
 XMASAMXAMM
 XXAMMXXAMA
 SMSMSASXSS
 SAXAMASAAA
 MAMMMXMMMM
 MXMXAXMASX
 In this word search, XMAS occurs a total of 18 times; here's the same word search again, but where letters not involved in any XMAS have been replaced with .:

 ....XXMAS.
 .SAMXMS...
 ...S..A...
 ..A.A.MS.X
 XMASAMX.MM
 X.....XA.A
 S.S.S.S.SS
 .A.A.A.A.A
 ..M.M.M.MM
 .X.X.XMASX
 Take a look at the little Elf's word search. How many times does XMAS appear?
 */

fileprivate func part1(_ file: String) throws -> Int {
    let lines = try readFile(file)
        .split(separator: "\n")
    var occurences: Int = 0

    for (lineIndex, line) in lines.enumerated() {
        let safeLineStart = 3
        let safeLineLength = line.count - 3
        let reverseLine = String(line.reversed())
        let split = line.split(separator: "XMAS", omittingEmptySubsequences: false)

        // [→] Horizontal occurences
        occurences += (split.count - 1)

        // [←] Horizontal occurences
        occurences += (reverseLine.split(separator: "XMAS", omittingEmptySubsequences: false).count - 1)

        // [↓] Vertical occurences
        if lineIndex < safeLineLength {
            for (charIndex, x) in line.enumerated() where x == "X" {
                let xString = String(x)
                let mString = String(lines[lineIndex + 1])[charIndex]!
                let aString = String(lines[lineIndex + 2])[charIndex]!
                let sString = String(lines[lineIndex + 3])[charIndex]!
                let xmasString = "\(xString)\(mString)\(aString)\(sString)"
                if xmasString == "XMAS" {
                    occurences += 1
                }
            }
        }

        // [↑] Vertical occurences
        if lineIndex >= safeLineStart {
            for (charIndex, x) in line.enumerated() where x == "X" {
                let xString = String(x)
                let mString = String(lines[lineIndex - 1])[charIndex]!
                let aString = String(lines[lineIndex - 2])[charIndex]!
                let sString = String(lines[lineIndex - 3])[charIndex]!
                let xmasString = "\(xString)\(mString)\(aString)\(sString)"
                if xmasString == "XMAS" {
                    occurences += 1
                }
            }
        }

        // [🡦] Diagonal occurences
        if lineIndex < safeLineLength {
            for (charIndex, x) in line.enumerated() where x == "X" && charIndex < safeLineLength {
                let xString = String(x)
                let mString = String(lines[lineIndex + 1])[charIndex + 1]!
                let aString = String(lines[lineIndex + 2])[charIndex + 2]!
                let sString = String(lines[lineIndex + 3])[charIndex + 3]!
                let xmasString = "\(xString)\(mString)\(aString)\(sString)"
                if xmasString == "XMAS" {
                    occurences += 1
                }
            }
        }

        // [🡥] Diagonal occurences
        if lineIndex >= safeLineStart {
            for (charIndex, x) in line.enumerated() where x == "X" && charIndex < safeLineLength {
                let xString = String(x)
                let mString = String(lines[lineIndex - 1])[charIndex + 1]!
                let aString = String(lines[lineIndex - 2])[charIndex + 2]!
                let sString = String(lines[lineIndex - 3])[charIndex + 3]!
                let xmasString = "\(xString)\(mString)\(aString)\(sString)"
                if xmasString == "XMAS" {
                    occurences += 1
                }
            }
        }

        // [🡧] Diagonal occurences
        if lineIndex < lines.count - 3 {
            for (charIndex, x) in line.enumerated() where x == "X" && charIndex >= safeLineStart {
                let xString = String(x)
                let mString = String(lines[lineIndex + 1])[charIndex - 1]!
                let aString = String(lines[lineIndex + 2])[charIndex - 2]!
                let sString = String(lines[lineIndex + 3])[charIndex - 3]!
                let xmasString = "\(xString)\(mString)\(aString)\(sString)"
                if xmasString == "XMAS" {
                    occurences += 1
                }
            }
        }

        // [🡤] Diagonal occurences
        if lineIndex >= safeLineStart {
            for (charIndex, x) in line.enumerated() where x == "X"  && charIndex >= safeLineStart {
                let xString = String(x)
                let mString = String(lines[lineIndex - 1])[charIndex - 1]!
                let aString = String(lines[lineIndex - 2])[charIndex - 2]!
                let sString = String(lines[lineIndex - 3])[charIndex - 3]!
                let xmasString = "\(xString)\(mString)\(aString)\(sString)"
                if xmasString == "XMAS" {
                    occurences += 1
                }
            }
        }
    }

    return occurences
}

@Test("https://adventofcode.com/2024/day/4")
func AdventOfCode_2024_04_example_part1() throws {
    let result = try part1("2024/04/example.txt")
    #expect(result == 18)
    print(result)
}

@Test
func tim() throws {
    let result = try part1("2024/04/tim.txt")
    #expect(result == 8)
}

@Test
func AdventOfCode_2024_04_part1() throws {
    let result = try part1("2024/04/input.txt")
    #expect(result == 2613)
}

/*
 --- Part Two ---

 The Elf looks quizzically at you. Did you misunderstand the assignment?

 Looking for the instructions, you flip over the word search to find that this isn't actually an XMAS puzzle; it's an X-MAS puzzle in which you're supposed to find two MAS in the shape of an X. One way to achieve that is like this:

 M.S
 .A.
 M.S
 Irrelevant characters have again been replaced with . in the above diagram. Within the X, each MAS can be written forwards or backwards.

 Here's the same example from before, but this time all of the X-MASes have been kept instead:

 .M.S......
 ..A..MSMS.
 .M.S.MAA..
 ..A.ASMSM.
 .M.S.M....
 ..........
 S.S.S.S.S.
 .A.A.A.A..
 M.M.M.M.M.
 ..........
 In this example, an X-MAS appears 9 times.

 Flip the word search from the instructions back over to the word search side and try again. How many times does an X-MAS appear?
 */

fileprivate func part2(_ file: String) throws -> Int {
    let lines = try readFile(file)
        .split(separator: "\n")
    var occurences: Int = 0

    for (lineIndex, line) in lines.enumerated() {
        let safeLineStart = 1
        let safeLineLength = line.count - 1

        if lineIndex > 0 && lineIndex < safeLineLength {
            for (charIndex, a) in line.enumerated() where a == "A" && charIndex >= safeLineStart && charIndex < safeLineLength {
                let upperLeft = String(String(lines[lineIndex - 1])[charIndex - 1]!)
                let upperRight = String(String(lines[lineIndex - 1])[charIndex + 1]!)
                let lowerLeft = String(String(lines[lineIndex + 1])[charIndex - 1]!)
                let lowerRight = String(String(lines[lineIndex + 1])[charIndex + 1]!)

                /*
                 M.S
                 .A.
                 M.S
                 */
                if upperLeft == "M" && lowerLeft == "M" && upperRight == "S" && lowerRight == "S" {
                    occurences += 1
                }

                /*
                 S.M
                 .A.
                 S.M
                 */
                if upperLeft == "S" && lowerLeft == "S" && upperRight == "M" && lowerRight == "M" {
                    occurences += 1
                }

                /*
                 M.M
                 .A.
                 S.S
                 */
                if upperLeft == "M" && upperRight == "M" && lowerLeft == "S" && lowerRight == "S" {
                    occurences += 1
                }

                /*
                 S.S
                 .A.
                 M.M
                 */
                if upperLeft == "S" && upperRight == "S" && lowerLeft == "M" && lowerRight == "M" {
                    occurences += 1
                }

            }
        }
    }

    return occurences
}

@Test
fileprivate func hint() throws {
    let result = try part2("2024/04/hint.txt")
    #expect(result == 1)
}

@Test
func AdventOfCode_2024_04_example_part2() throws {
    let result = try part2("2024/04/example.txt")
    #expect(result == 9)
}

@Test
func AdventOfCode_2024_04_part2() throws {
    let result = try part2("2024/04/input.txt")
    #expect(result == 1905)
}
