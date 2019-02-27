import Rainbow

extension String: Error {
  var trimmed: String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }

  func truncated(_ limit: Int, del: String = "…") -> String {
    if count < limit { return self }
    return String(characters.prefix(limit - 1)) + del
  }

  public var hl: String {
    return italic.lightYellow
  }
}
