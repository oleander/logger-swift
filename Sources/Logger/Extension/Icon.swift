extension Logger {
  public enum Icon: String {
    case done = "✔"
    case heart = "♥"
    case fail = "✖"

    public var terminal: String {
      switch self {
      case .done:
        return rawValue.lightGreen
      case .heart:
        return rawValue.lightRed
      case .fail:
        return rawValue.lightRed
      }
    }
  }
}
