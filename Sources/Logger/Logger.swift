// https://github.com/klauscfhq/signale
#if os(Linux)
  import Glibc
#else
  import Darwin
#endif
import Foundation
import Rainbow

private struct StderrOutputStream: TextOutputStream {
  public mutating func write(_ string: String) { fputs(string, stderr) }
}

private struct StdoutOutputStream: TextOutputStream {
  public mutating func write(_ string: String) { fputs(string, stdout) }
}

public class Logger {
  let colors: [Color] = [
    .black, .red, .green, .yellow, .blue, .magenta, .cyan,
    .white, .lightBlack, .lightRed, .lightGreen, .lightYellow,
    .lightBlue, .lightMagenta, .lightCyan, .lightWhite
  ]

  private var errStream = StderrOutputStream()
  private var outStream = StdoutOutputStream()

  let tags: [String]
  public var level: Level
  private let time: Bool

  public init(_ level: Level? = nil, time: Bool = false, tags: [String] = []) {
    self.tags = tags
    self.time = time

    for key in ["DEBUG", "debug"] {
      if ProcessInfo.processInfo.environment[key] != nil {
        self.level = .debug
        return
      }
    }

    if let level = level {
      self.level = level
      return
    } else {
      for key in ["DEBUG", "debug"] {
        if ProcessInfo.processInfo.environment[key] != nil {
          self.level = .debug
          warn("Found \(key) as env variable, use \(self.level) level")
          return
        }
      }

      for key in ["VERBOSE", "verbose"] {
        if ProcessInfo.processInfo.environment[key] != nil {
          self.level = .verbose
          warn("Found \(key) as env variable, use \(self.level) level")
          return
        }
      }

      for argument in CommandLine.arguments {
        if argument == "--debug" {
          self.level = .debug
          warn("Found \(argument) as argument, use \(self.level) level")
          return
        }
      }

      for key in ["INFO", "info"] {
        if ProcessInfo.processInfo.environment[key] != nil {
          self.level = .info
          warn("Found \(key) as env variable, use \(self.level) level")
          return
        }
      }
    }

    if CommandLine.arguments.count >= 2 {
      if CommandLine.arguments[1].contains("/debug/") {
        self.level = .debug
        warn("Found /debug/ in path, use \(self.level) level")
      } else if CommandLine.arguments[1].contains(".xctest") {
        self.level = .verbose
        warn("Found .xctest in path, use \(self.level) level")
      } else {
        self.level = .info
      }
    } else {
      self.level = .info
    }

    if inDebugMode {
      warn("In debug mode")
    }
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
    output(.warn, ["⚠".blink.red] + message)
  }

  public func todo(_ message: Any...) {
    output(.warn, ["TODO"] + message)
  }

  public func verbose(_ message: Any..., tag: String? = nil) {
    output(.verbose, message)
  }

  public func debug(_ message: Any..., tag: String? = nil) {
    output(.debug, message)
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

  public func info(_ message: Any..., tag: String? = nil) {
    output(.info, message)
  }

  public func error(_ message: Any..., tag: String? = nil) {
    output(.error, message)
  }

  private func output(_ level: Level, _ message: [Any]) {
    guard level >= self.level else { return }
    let formatter = DateFormatter()

    formatter.dateFormat = "HH:mm:ss"
    var params = [String]()

    switch level {
    case .info:
      params.append("●".lightGreen)
    case .warn:
      params.append("●".lightYellow)
    case .error:
      params.append("●".lightRed)
    case .bug:
      params.append("●".red)
    case .debug:
      params.append("●".lightBlue)
    case .verbose:
      params.append("●".lightCyan)
    }

    if time {
      let raw = formatter.string(from: Date())
      params.append("[\(raw)]".dim)
    }

    params.append(message.map(stringify).joined(separator: " "))

    let data = params.joined(separator: " ")

    switch level {
    case .error:
      print(data, to: &errStream)
    default:
      print(data, to: &outStream)
    }
  }

  private func stringify(_ error: Error) -> String {
    return error.localizedDescription
  }

  private func stringify<T: CustomStringConvertible>(_ message: T) -> String {
    return String(describing: message)
  }

  private func stringify(_ message: Any) -> String {
    return String(describing: message)
  }
}
