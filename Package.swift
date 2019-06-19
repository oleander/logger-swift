// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Logger",
    products: [
      .library(
        name: "Logger",
        targets: ["Logger"]
      )
    ],
    dependencies: [
      .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.1.5"),
      .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.2"),
      .package(url: "https://github.com/Quick/Quick.git", from: "2.1.0")
    ],
    targets: [
      .target(
        name: "Logger",
        dependencies: ["Rainbow"]),
      .testTarget(
        name: "LoggerTests",
        dependencies: ["Logger", "Quick", "Nimble"])
    ],
    swiftLanguageVersions: [.v4, .v4_2]
)
