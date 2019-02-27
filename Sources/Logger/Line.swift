// https://github.com/klauscfhq/signale
// https://github.com/sindresorhus/figures/blob/HEAD/index.js

#if os(Linux)
import Glibc
#else
import Darwin
#endif
import Foundation
import Rainbow

public class Line {
  public var tags: [String]
  public var level: Level
  private let time: Bool
  private let indentation: Int
  private let status: Bool
  private let content: [Any]
  private let icon: Logger.Icon?
  private let blink: Bool

  public init(
    level: Level,
    content: [Any],
    time: Bool = false,
    tags: [String] = [],
    tag: String? = nil,
    icon: Logger.Icon? = nil,
    status: Bool = true,
    indentation: Int = 0,
    blink: Bool = false
    ) {

    var endTags = tags

    if let tag = tag {
      endTags.append(tag)
    }

    self.tags = endTags
    self.status = status
    self.time = time
    self.icon = icon
    self.indentation = indentation
    self.level = level
    self.content = content
    self.blink = blink
  }

  public func verbose(_ message: Any..., tag: String? = nil, icon: Logger.Icon? = nil, block: ((ListLog) -> Void)? = nil) {
    print(Line(
      level: .verbose,
      content: content,
      tags: tags,
      tag: tag,
      icon: icon,
      indentation: indentation
    ).render())

    if let block = block {
      let list = ListLog()
      block(list)
      list.output { row in
        print(Line(
          level: .verbose,
          content: [row],
          icon: icon,
          status: false,
          indentation: indentation + 1
        ).render())
      }
    }
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

  var str: String {
    return content.map(stringify).joined(separator: " ")
  }

  public func render() -> String {
    var params = [String]()

    if let icon = icon {
      params.append(icon.terminal)
    } else if status {
      params.append(statusIcon(for: level))
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

    if !status {
      params.append(str)
      return params.joined(separator: " ")
    }

    if time {
      let formatter = DateFormatter()
      formatter.dateFormat = "HH:mm:ss"
      let raw = formatter.string(from: Date())
      params.append("[\(raw)]".dim)
    }


    if !tags.isEmpty {
      params.append("\(tags.joined(separator: " › "))".dim)
      params.append("›".dim)
    }

    if blink {
      params[params.count - 1] = params.last!.blink
    }

    params.append(str)

    return params.joined(separator: " ")
  }

  private func stringify<T: Printable>(_ object: T) -> String {
    return object.printable
  }

  private func stringify(_ message: Any) -> String {
    return String(describing: message)
  }
}
