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

  private func dash(_ number: Int) -> String {
    return String(repeating: "-", count: number)
  }

  public func ln(_ message: String? = nil) {
    let columns = 110

    guard let message = message else {
      return ret(Line(
        level: .info,
        content: [dash(columns)],
        status: false
      ))
    }

    let dashes = columns - message.count

    guard dashes > 2 else {
      return ret(Line(
        level: .info,
        content: [message],
        status: false
      ))
    }

    let half = Int(dashes / 2)

    var endDash = dash(half - 1)
    if (dashes % 2) != 0 {
      endDash = dash(half)
    }

    let content = dash(half - 1) + " " + message + " " + endDash

    ret(Line(
      level: .info,
      content: [content],
      status: false
    ))
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
    ))
  }

  public func blink(_ message: Any..., tag: String? = nil, icon: Icon? = nil) {
    ret(Line(
      level: .warn,
      content: [message],
      tags: tags(tag),
      icon: icon,
      indentation: indentation,
      blink: true
    ))
  }

  public func todo(_ message: Any..., tag: String? = nil, icon: Icon? = nil) {
    ret(Line(
      level: .warn,
      content: message,
      tags: tags(tag, extra: "TODO"),
      icon: icon,
      indentation: indentation
    ))
  }

  public func verbose(_ message: Any..., tag: String? = nil, icon: Icon? = nil, block: ((ListLog) -> Void)? = nil) {
    ret(Line(
      level: .verbose,
      content: message,
      tags: tags(tag),
      icon: icon,
      indentation: indentation
    ))

    if let block = block {
      let list = ListLog()
      block(list)
      list.output { row in
        ret(Line(
          level: .verbose,
          content: [row],
          status: false,
          indentation: indentation + 1
        ))
      }
    }
  }

  public func debug(
    _ message: Any...,
    tag: String? = nil,
    icon: Icon? = nil,
    block: ((ListLog) -> Void)? = nil
  ) {
    ret(Line(
      level: .debug,
      content: message,
      tags: tags(tag),
      icon: icon,
      indentation: indentation
    ))

    if let block = block {
      let list = ListLog()
      block(list)
      list.output { row in
        ret(Line(
          level: .debug,
          content: [row],
          status: false,
          indentation: indentation + 1
        ))
      }
    }
  }

  public func abort(
    _ message: Any...,
    tag: String? = nil,
    icon: Icon? = nil
  ) -> Never {
    ret(Line(
      level: .warn,
      content: message,
      tags: tags(tag),
      icon: icon,
      indentation: indentation
    ))

    exit(0)
  }

  public func warn(
    _ message: Any...,
    tag: String? = nil,
    icon: Icon? = nil,
    block: ((ListLog) -> Void)? = nil
  ) {
    ret(Line(
      level: .warn,
      content: message,
      tags: tags(tag),
      icon: icon,
      indentation: indentation
    ))

    if let block = block {
      let list = ListLog()
      block(list)
      list.output { row in
        ret(Line(
          level: .warn,
          content: [row],
          status: false,
          indentation: indentation + 1
        ))
      }
    }
  }

  public func bug(
    _ message: Any...,
    tag: String? = nil,
    icon: Icon? = nil
  ) -> Never {
    ret(Line(
      level: .bug,
      content: message,
      tags: tags(tag),
      icon: icon,
      indentation: indentation
    ))

    exit(1)
  }

  public func info(
    _ message: Any...,
    tag: String? = nil,
    icon: Icon? = nil,
    block: ((ListLog) -> Void)? = nil
  ) {
    ret(Line(
      level: .info,
      content: message,
      tags: tags(tag),
      icon: icon,
      indentation: indentation
    ))

    if let block = block {
      let list = ListLog()
      block(list)
      list.output { row in
        ret(Line(
          level: .info,
          content: [row],
          status: false,
          indentation: indentation + 1
        ))
      }
    }
  }

  public func error(
    _ message: Any...,
    tag: String? = nil,
    icon: Icon? = nil,
    block: ((ListLog) -> Void)? = nil
  ) {
    ret(Line(
      level: .error,
      content: message,
      tags: tags(tag),
      icon: icon,
      indentation: indentation
    ))

    let list = ListLog()
    block?(list)
    list.output { row in
      ret(Line(
        level: .error,
        content: [row],
        status: false,
        indentation: indentation + 1
      ))
    }

    if !Thread.callStackSymbols.isEmpty {
      for sym in Thread.callStackSymbols[0..<4] {
        ret(Line(
          level: .error,
          content: [clean(trace: sym).dim],
          status: false,
          indentation: indentation + 1
        ))
      }
    }
  }

  private func tags(_ tag: String? = nil, extra: String? = nil) -> [String] {
    if level > .debug {
      return []
    }

    var allTags = tags

    if let tag = tag {
      allTags.append(tag)
    }

    if let tag = extra {
      allTags.append(tag)
    }

    return allTags
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

  private func ret(_ line: Line) {
    guard line.level >= self.level else {
      return
    }

    switch level {
    case .info:
      plainStdout(line.render())
    default:
      plainStderr(line.render())
    }
  }

  private func plainStdout(_ data: String) {
    print(data, to: &outStream)
  }

  private func plainStderr(_ data: String) {
    print(data, to: &errStream)
  }
}
