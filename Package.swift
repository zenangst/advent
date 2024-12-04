// swift-tools-version:6.0
import PackageDescription

let package = Package(
  name: "AdventOfCode",
  platforms: [.macOS(.v15)],
  products: [
    .library(name: "AdventOfCode2024", targets: ["AdventOfCode2024"]),
  ],
  targets: [
    .target(name: "AdventOfCode2024", dependencies: []),
    .testTarget(name: "AdventOfCode24Tests", dependencies: ["AdventOfCode2024"]),
  ]
)


