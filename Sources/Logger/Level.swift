import Foundation
import RainbowSwift

public enum Level: Int, Comparable, CustomStringConvertible {
  case verbose = 0
  case debug = 1
  case info = 2
  case warn = 3
  case error = 4
  case bug = 5

  public var description: String { return name }

  public init(_ string: String) throws {
    switch string {
    case "verbose":
      self = .verbose
    case "debug":
      self = .debug
    case "info":
      self = .info
    case "warn":
      self = .warn
    case "error":
      self = .error
    case "bug":
      self = .bug
    default:
      throw "Invalid level: '\(string)'"
    }
  }

  public static func < (lhs: Level, rhs: Level) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }

  public static func == (lhs: Level, rhs: Level) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }

  public var color: ((String) -> String) {
    return [
      .verbose: { $0.lightRed },
      .debug: { $0.cyan },
      .info: { $0.lightBlue },
      .warn: { $0.yellow },
      .error: { $0.red },
      .bug: { $0.red.blink }
    ][self]!
  }

  private var name: String {
    switch self {
    case .verbose:
      return "Verb"
    case .debug:
      return "Debu"
    case .info:
      return "Info"
    case .warn:
      return "Warn"
    case .error:
      return "Erro"
    case .bug:
      return "Bug"
    }
  }

  public var tag: String {
    return color(name)
  }
}
