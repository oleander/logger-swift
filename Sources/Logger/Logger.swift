// https://github.com/klauscfhq/signale
// https://github.com/sindresorhus/figures/blob/HEAD/index.js

#if os(Linux)
import Glibc
#else
import Darwin
#endif
import Foundation
import Rainbow

public class Logger {
  private var errStream = StderrOutputStream()
  private var outStream = StdoutOutputStream()

  public var tags: [String]
  public var level: Level
  private let time: Bool
  private let indentation: Int

  public init(
    _ level: Level? = nil,
    time: Bool = false,
    tags _tags: [String] = [],
    _ _tag: String? = nil,
    indentation: Int = 0
    ) {

    var tags = [String]()
    if let tag = _tag {
      tags.append(tag)
    }

    tags += _tags

    self.tags = tags
    self.time = time
    self.indentation = indentation

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

    for argument in CommandLine.arguments {
      if argument == "--verbose" {
        return .verbose
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
    ret(Line(
      level: .info,
      content: [String(repeating: "-", count: 60)],
      status: false
    ).render())
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

  public func build(_ message: [Any], level: Level, icon: Icon) {
    ret(Line(
      level: level,
      content: message,
      icon: icon,
      indentation: indentation
    ).render())
  }

  public func blink(_ message: Any..., tag: String? = nil, icon: Icon? = nil) {
    ret(Line(
      level: .warn,
      content: [message],
      tags: tags,
      tag: tag,
      icon: icon,
      indentation: indentation,
      blink: true
    ).render())
  }

  public func todo(_ message: Any..., tag: String? = nil, icon: Icon? = nil) {
    ret(Line(
      level: .warn,
      content: message,
      tags: ["TODO"] + tags,
      tag: tag,
      icon: icon,
      indentation: indentation
    ).render())
  }

  public func verbose(_ message: Any..., tag: String? = nil, icon: Icon? = nil, block: ((ListLog) -> Void)? = nil) {
    ret(Line(
      level: .verbose,
      content: message,
      tags: tags,
      tag: tag,
      icon: icon,
      indentation: indentation
    ).render())

    if let block = block {
      let list = ListLog()
      block(list)
      list.output { row in
        ret(Line(
          level: .verbose,
          content: [row],
          status: false,
          indentation: indentation + 1
        ).render())
      }
    }
  }

  public func debug(_ message: Any..., tag: String? = nil, icon: Icon? = nil, block: ((ListLog) -> Void)? = nil) {
    ret(Line(
      level: .debug,
      content: message,
      tags: tags,
      tag: tag,
      icon: icon,
      indentation: indentation
    ).render())

    if let block = block {
      let list = ListLog()
      block(list)
      list.output { row in
        ret(Line(
          level: .debug,
          content: [row],
          status: false,
          indentation: indentation + 1
        ).render())
      }
    }
  }

  public func abort(_ message: Any..., tag: String? = nil, icon: Icon? = nil) -> Never {
    ret(Line(
      level: .warn,
      content: message,
      tags: tags,
      tag: tag,
      icon: icon,
      indentation: indentation
    ).render())

    exit(0)
  }

  public func warn(_ message: Any..., tag: String? = nil, icon: Icon? = nil, block: ((ListLog) -> Void)? = nil) {
    ret(Line(
      level: .warn,
      content: message,
      tags: tags,
      tag: tag,
      icon: icon,
      indentation: indentation
    ).render())

    if let block = block {
      let list = ListLog()
      block(list)
      list.output { row in
        ret(Line(
          level: .warn,
          content: [row],
          status: false,
          indentation: indentation + 1
        ).render())
      }
    }
  }

  public func bug(_ message: Any..., tag: String? = nil, icon: Icon? = nil) -> Never {
    ret(Line(
      level: .bug,
      content: message,
      tags: tags,
      tag: tag,
      icon: icon,
      indentation: indentation
    ).render())

    exit(1)
  }

  public func info(_ message: Any..., tag: String? = nil, icon: Icon? = nil, block: ((ListLog) -> Void)? = nil) {
    ret(Line(
      level: .info,
      content: message,
      tags: tags,
      tag: tag,
      icon: icon,
      indentation: indentation
    ).render())


    if let block = block {
      let list = ListLog()
      block(list)
      list.output { row in
        ret(Line(
          level: .info,
          content: [row],
          status: false,
          indentation: indentation + 1
        ).render())
      }
    }
  }

  public func error(_ message: Any..., tag: String? = nil, icon: Icon? = nil, block: ((ListLog) -> Void)? = nil) {
    ret(Line(
      level: .error,
      content: message,
      tags: tags,
      tag: tag,
      icon: icon,
      indentation: indentation
    ).render())

    let list = ListLog()
    block?(list)
    list.output { row in
      ret(Line(
        level: .error,
        content: [row],
        status: false,
        indentation: indentation + 1
      ).render())
    }

    if !Thread.callStackSymbols.isEmpty {
      for sym in Thread.callStackSymbols[0..<4] {
        output(.error, [clean(trace: sym).dim], status: false, indentation: 1)
      }
    }
  }

  private func clean(trace: String) -> String {
    let splits = trace
      .split(separator: " ")
      .map { String($0).trimmed }

    guard splits.count >= 4 else {
      return splits.joined(separator: " ")
    }

    var params = [String]()

    params.append("at")

    params.append(splits[1])
    params.append("(\(splits[3].truncated(80)))")

    return params.joined(separator: " ")
  }

  private func statusIcon(for level: Level) -> String {
    switch OutputTarget.current {
    case .xcodeColors, .console:
      return coloredStatusIcon(for: level)
    default:
      return plainStatusIcon(for: level)
    }
  }

  private func coloredStatusIcon(for level: Level) -> String {
    switch level {
    case .info:
      return "●".lightBlue
    case .warn:
      return "●".yellow
    case .error:
      return "●".red
    case .bug:
      return "●".red
    case .debug:
      return "●".lightMagenta
    case .verbose:
      return "●".lightCyan
    }
  }

  private func plainStatusIcon(for level: Level) -> String {
    switch level {
    case .info:
      return "[I]"
    case .warn:
      return "[W]"
    case .error:
      return "[E]"
    case .bug:
      return "[B]"
    case .debug:
      return "[D]"
    case .verbose:
      return "[V]"
    }
  }

  private func output(
    _ level: Level,
    _ message: [Any],
    tags: [String] = [],
    blink: Bool = false,
    tag: String? = nil,
    icon: Icon? = nil,
    status: Bool = true,
    indentation extraIndentation: Int = 0
  ) {
    guard level >= self.level else {
      return
    }

    let str = message.map(stringify).joined(separator: " ")
    var params = [String]()

    if let icon = icon {
      params.append(icon.terminal)
    } else if status {
      params.append(statusIcon(for: level))
    } else {
      params.append(" ")
    }

    let allIndent = indentation + extraIndentation

    switch allIndent {
    case 0:
      break
    case 1:
      params.append(" ")
    default:
      params.append(String(repeating: "  ", count: allIndent))
    }

    if !status {
      params.append(str)
      return ret(params.joined(separator: " "))
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

    if self.level <= .debug && !allTags.isEmpty {
      params.append("\(allTags.joined(separator: " › "))".dim)
      params.append("›".dim)
    } else if let tag = tag {
      params.append(tag.dim)
      params.append("›".dim)
    }

    if blink {
      params[params.count - 1] = params.last!.blink
    }

    params.append(str)

    ret(params.joined(separator: " "))
  }

  private func ret(_ data: String) {
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

  private func stringify<T: Printable>(_ object: T) -> String {
    return object.printable
  }

  private func stringify(_ message: Any) -> String {
    return String(describing: message)
  }
}
