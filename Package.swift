// swift-tools-version:4.0

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
      .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "3.1.4"),
      .package(url: "https://github.com/onevcat/Rainbow.git", from: "2.1.0"),
      .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.2"),
      .package(url: "https://github.com/Quick/Quick.git", from: "1.2.0")
    ],
    targets: [
      .target(
        name: "Logger",
        dependencies: ["Rainbow", "SwiftyJSON"]),
      .testTarget(
        name: "LoggerTests",
        dependencies: ["Logger", "Quick", "Nimble"]),
    ]
)
