import Foundation

public struct ListItem {
  public let key: String
  public let value: Any

  public var count: Int {
    return key.count
  }

  private func toString<T: StringProtocol>(_ array: Array<T>) -> String {
    return array.map { String(describing: $0 ) }.joined(separator: ", ")
  }

  private func toString<T>(_ any: T) -> String {
    return String(describing: any)
  }

  private var strValue: String {
    if let bool = value as? Bool {
      return bool ? "yes".lightGreen.dim : "no".lightRed.dim
    }

    return toString(value)
  }

  private func paddedKey(_ indent: Int) -> String {
    return key.padding(toLength: indent, withPad: " ", startingAt: 0)
  }

  public func formatted(indent: Int) -> String {
    return paddedKey(indent) + ": " + strValue
  }
}
