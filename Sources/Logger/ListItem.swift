import Foundation

public struct ListItem {
  public let key: String
  public let value: Any

  public var count: Int {
    return key.count
  }

  private var strValue: String {
    if let bool = value as? Bool {
      return bool ? "yes".lightGreen.dim : "no".lightRed.dim
    }

    return String(describing: value)
  }

  private func paddedKey(_ indent: Int) -> String {
    return key.padding(toLength: indent, withPad: " ", startingAt: 0)
  }

  public func formatted(indent: Int) -> String {
    return paddedKey(indent) + ": " + strValue
  }
}
