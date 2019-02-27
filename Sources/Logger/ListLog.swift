import Foundation

public class ListLog {
  private var items: [ListItem] = []

  public func kv(_ key: String, _ value: Any) {
    items.append(ListItem(key: key, value: value))
  }

  public func output(block: (String) -> Void) {
    if items.isEmpty { return }

    let longestKeyLength = items.sorted { $0.count > $1.count }.first!.count

    for item in items {
      block(item.formatted(indent: longestKeyLength).dim)
    }
  }
}
