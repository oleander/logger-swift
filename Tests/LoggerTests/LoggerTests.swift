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

    describe("icons") {
      it("has icons") {
        log.info("It has a checkbox", icon: .done)
        log.info("It has a heart", icon: .heart)
      }
    }

    describe("line") {
      it("prints") {
        log.info("This is before the line")
        log.ln()
        log.info("This is after the line")
      }
    }

    describe("list") {
      it("prints") {
        let log = Logger(.info)
        let nest1 = log.info("This is a list")
        nest1.kv("Key 1", "Value 1")
        nest1.kv("Key 2", "Value 2")
        nest1.kv("Key 3", "Value 3")

        let nest2 = log.debug("Should not be visible")
        nest2.kv("Invisible 1", "Value 1")
        nest2.kv("Invisible 2", "Value 2")
        nest2.kv("Invisible 3", "Value 3")
      }

      it("prints block") {
        let log = Logger(.info)
        let nest1 = log.info("This is a list") { list in
          list.kv("Key 1", "Value 1")
          list.kv("Key 2", "Value 2")
          list.kv("Key 3", "Value 3")
        }

        nest1.kv("Key 4", "Value 4")

        let nest2 = log.debug("This is a list") { list in
          list.kv("Not visible", "Value 1")
          list.kv("Not visible", "Value 2")
          list.kv("Not visible", "Value 3")
        }

        nest2.kv("Not visible", "Value 4")
      }
    }
  }
}
