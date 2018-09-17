# Logger

![Printscreen](Resources/printscreen.png)

Swift log library

## Example

``` swift
import Logger

// Optional, default level: .info
let log = Logger(.info)

log.info("This is info")
log.warn("This is warn")
log.error("This is error")
log.debug("This is debug")
```

## Install

``` swift
// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "YOUR_PROJECT_NAME",
  dependencies: [
    .package(url: "https://github.com/oleander/swift-logger.git", .branch("master")),
  ]
)
```
