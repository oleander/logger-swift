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
  }
}
