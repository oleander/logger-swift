import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(logger_swiftTests.allTests),
    ]
}
#endif