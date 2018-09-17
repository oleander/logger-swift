import XCTest

import Logger

var tests = [XCTestCaseEntry]()
tests += Logger.allTests()
XCTMain(tests)
