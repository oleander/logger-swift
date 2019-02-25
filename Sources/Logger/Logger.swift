// https://github.com/klauscfhq/signale
#if os(Linux)
  import Glibc
#else
  import Darwin
#endif
import Foundation
import Rainbow

public class Logger {
  public enum Icon: String {
    case done = "✔"
    case heart = "♥"

    public var terminal: String {
      switch self {
      case .done:
        return rawValue.lightGreen
      case .heart:
        return rawValue.lightRed
      }
    }
  }

  let colors: [Color] = [
    .black, .red, .green, .yellow, .blue, .magenta, .cyan,
    .white, .lightBlack, .lightRed, .lightGreen, .lightYellow,
    .lightBlue, .lightMagenta, .lightCyan, .lightWhite
  ]

  private var errStream = StderrOutputStream()
  private var outStream = StdoutOutputStream()

  private let tags: [String]
  public var level: Level
  private let time: Bool
  private let indentation: Int
  private let prevLevel: Level?

  public init(_ level: Level? = nil, time: Bool = false, tags: [String] = [], indentation: Int = 0, prevLevel: Level? = nil) {
    self.tags = tags
    self.time = time
    self.indentation = indentation
    self.prevLevel = prevLevel

    if let level = level {
      self.level = level
    } else {
      self.level = Logger.preLevel
    }
  }

  public func indent() -> Logger {
    return Logger(level, time: time, tags: tags, indentation: indentation + 1)
  }

  private static var preLevel: Level {
    for key in ["DEBUG", "debug"] {
      if ProcessInfo.processInfo.environment[key] != nil {
        return .debug
      }
    }

    for key in ["VERBOSE", "verbose"] {
      if ProcessInfo.processInfo.environment[key] != nil {
        return .verbose
      }
    }

    for argument in CommandLine.arguments {
      if argument == "--debug" {
        return .debug
      }
    }

    for key in ["INFO", "info"] {
      if ProcessInfo.processInfo.environment[key] != nil {
        return .info
      }
    }

    if CommandLine.arguments.count >= 2 {
      if CommandLine.arguments[1].contains("/debug/") {
        return .debug
      } else if CommandLine.arguments[1].contains(".xctest") {
        return .verbose
      } else {
        return .info
      }
    }

    return .info
  }

  public func ln() {
    plainStdout(String(repeating: "-", count: 60))
  }

  public var inDebugMode: Bool {
    return level <= .debug
  }

  public static func new(_ tag: String) -> Logger {
    return log.new(tag)
  }

  public func new(_ tag: String) -> Logger {
    return Logger(level, tags: tags + [tag])
  }

  public func blink(_ message: Any...) {
    output(.warn, message, blink: true)
  }

  public func todo(_ message: Any...) {
    output(.warn, message, tags: ["TODO"])
  }

  public func verbose(_ message: Any..., tag: String? = nil) {
    output(.verbose, message)
  }

  @discardableResult
  public func debug(_ message: Any..., tag: String? = nil, block: ((Logger) -> Void)? = nil) -> Logger {
    output(.debug, message)

    let newLogger = Logger(level, tags: tags, prevLevel: .debug)

    if let block = block {
      block(newLogger)
    }

    return newLogger
  }

  public func abort(_ message: Any...) -> Never {
    output(.warn, message)
    exit(0)
  }

  public func warn(_ message: Any...) {
    output(.warn, message)
  }

  public func bug(_ message: Any...) -> Never {
    output(.bug, message)
    exit(1)
  }

  @discardableResult
  public func info(_ message: Any..., tag: String? = nil, icon: Icon? = nil, block: ((Logger) -> Void)? = nil) -> Logger {
    output(.info, message, tag: tag, icon: icon)
    let newLogger = Logger(level, tags: tags, prevLevel: .info)

    if let block = block {
      block(newLogger)
    }

    return newLogger
  }

  public func kv(_ key: Any, _ value: Any) {
    let indent = String(repeating: " ", count: 3)
    let res = stringify(key) + ": " + stringifyWithColor(value).italic
    output(level, [indent + res.dim], status: false)
  }

  public func error(_ message: Any..., tag: String? = nil) {
    output(.error, message)
  }

  private func output(_ level: Level, _ message: [Any], tags: [String] = [], blink: Bool = false, tag: String? = nil, icon: Icon? = nil, status: Bool = true) {
    guard level >= self.level else {
      return
    }

    if let prevLevel = prevLevel, prevLevel < self.level {
      return
    }

    var params = [String]()

    if status {
      switch level {
      case .info:
        params.append("●".lightBlue)
      case .warn:
        params.append("●".lightYellow)
      case .error:
        params.append("●".lightRed)
      case .bug:
        params.append("●".lightRed)
      case .debug:
        params.append("●".lightMagenta)
      case .verbose:
        params.append("●".lightCyan)
      }
    } else {
      params.append(" ")
    }

    switch indentation {
    case 0:
      break
    case 1:
      params.append(" ")
    default:
      params.append(String(repeating: "  ", count: indentation))
    }

    if time {
      let formatter = DateFormatter()
      formatter.dateFormat = "HH:mm:ss"
      let raw = formatter.string(from: Date())
      params.append("[\(raw)]".dim)
    }

    var allTags = self.tags + tags

    if let tag = tag {
      allTags.append(tag)
    }

    if level <= .debug && !allTags.isEmpty {
      params.append("\(allTags.joined(separator: " › "))".dim)
    }

    if blink {
      params[params.count - 1] = params.last!.blink
    }

    if let icon = icon {
      params.append(icon.terminal)
    }

    params.append(message.map(stringify).joined(separator: " "))

    let data = params.joined(separator: " ")

    switch level {
    case .info:
      plainStdout(data)
    default:
      plainStderr(data)
    }
  }

  private func plainStdout(_ data: String) {
    print(data, to: &outStream)
  }

  private func plainStderr(_ data: String) {
    print(data, to: &errStream)
  }

  private func stringify(_ error: Error) -> String {
    return error.localizedDescription
  }

  private func stringifyWithColor(_ value: Bool) -> String {
    if value {
      return "yes".lightGreen.dim
    } else {
      return "no".lightRed.dim
    }
  }

  private func stringifyWithColor(_ message: Any) -> String {
    return String(describing: message)
  }

  private func stringify<T: CustomStringConvertible>(_ message: T) -> String {
    return String(describing: message)
  }

  private func stringify(_ message: Any) -> String {
    return String(describing: message)
  }
}
