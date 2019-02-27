import Foundation

public struct ListItem {
  public let key: String
  public let value: Any

  public var count: Int {
    return key.count
  }

  public func formatted(indent: Int) -> String {
    let paddedStr = key.padding(toLength: indent, withPad: " ", startingAt: 0)
    return paddedStr + ": " + String(describing: value)
  }
}
