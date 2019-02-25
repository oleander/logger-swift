@testable import Logger

import Quick
import Nimble

class LoggerTests: QuickSpec {
  override func spec() {
    describe("stdout") {
      it("prints") {
        log.info("This is info")
        log.warn("This is warn")
        log.error("This is error")
        log.debug("This is debug")
      }
    }

    describe("time") {
      it("prints") {
        let log = Logger(.debug, time: true)
        log.info("This is info")
        log.warn("This is warn")
        log.error("This is error")
        log.debug("This is debug")
      }
    }

    describe("tags") {
      it("prints") {
        let log = Logger(.debug, tags: ["a", "b", "c"])
        log.info("This is info")
        log.warn("This is warn")
        log.error("This is error")
        log.debug("This is debug")
      }

      it("does not print") {
        let log = Logger(.info, tags: ["a", "b", "c"])
        log.info("This is info")
        log.warn("This is warn")
        log.error("This is error")
        log.debug("This is debug")
      }
    }

    describe("blink") {
      it("blinks") {
        log.blink("This is blink!")
      }
    }

    describe("TODO") {
      it("prints") {
        log.todo("Hello!")
      }
    }

    describe("indentation") {
      it("prints") {
        let log = Logger()
        log.info("Indent 1")
        let log1 = log.indent()
        log1.info("Indent 2")
        let log2 = log1.indent()
        log2.info("Indent 3")
        let log3 = log2.indent()
        log3.info("Indent 4")
        log2.info("Indent 3")
        log2.info("Indent 3")
        log1.info("Indent 2")
      }
    }
  }
}
