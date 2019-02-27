@testable import Logger

import Quick
import Nimble

extension Logger {
  func fail(_ message: Any...) {
    log.build(message, level: .warn, icon: .fail)
  }
}

class LoggerTests: QuickSpec {
  override func spec() {
    describe("error") {
      it("prints") {
        do {
          throw "This is an error message"
        } catch {
          log.error("This is an error", error)
        }
      }
    }

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

    fdescribe("fail") {
      it("prints") {
        log.fail("This is a fail test")
      }
    }

    describe("list") {
      // it("prints") {
      //   let log = Logger(.info)
      //   let nest1 = log.info("This is a list")
      //   nest1.kv("Key 1", "Value 1")
      //   nest1.kv("Key 2", "Value 2")
      //   nest1.kv("Key 3", "Value 3")
      //
      //   let nest2 = log.debug("Should not be visible")
      //   nest2.kv("Invisible 1", "Value 1")
      //   nest2.kv("Invisible 2", "Value 2")
      //   nest2.kv("Invisible 3", "Value 3")
      // }

      it("prints block") {
        let log = Logger(.info)
        log.info("This is a list") { list in
          list.kv("Key 1", "Value 1")
          list.kv("This is false", false)
          list.kv("Key 3", "Value 3")
          list.kv("This is true", true)
        }

        log.debug("This is a list") { list in
          list.kv("Not visible", "Value 1")
          list.kv("Not visible", "Value 2")
          list.kv("Not visible", "Value 3")
        }
      }

      it("does not print tags in list") {
        log.info("This is a list with tags", tag: "My TAG!") { list in
          list.kv("Does not have a tag 1", "Value 1")
          list.kv("Does not have a tag 2", "Value 2")
        }
      }
    }

    describe("tags") {
      it("prints again") {
        let log = Logger(.debug, time: true)
        log.tags.append("TAG!")
        log.info("This is info")
        log.warn("This is warn")
        log.error("This is error")
        log.debug("This is debug")
      }

      it("prints") {
        let log = Logger(.debug, tags: ["A", "B", "C"])
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

    describe("tags bug") {
      it("works") {
        let log = Logger(.debug, "XXX")
        log.info("Hello!")
      }
    }

    describe("example") {
      it("prints") {
        let log = Logger(.info, time: true)

        log.info("This is info")
        log.warn("This is warn")
        log.error("This is error")
        log.debug("This is debug")

        log.info("This is a table") { table in
          table.kv("Key 1", "Value 1")
          table.kv("Key 2", "Value 2")
        }
      }
    }
  }
}
