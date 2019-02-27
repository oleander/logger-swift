extension Logger {
  public enum Icon: String {
    case done = "✔"
    case heart = "♥"

    public var terminal: String {
      switch self {
      case .done:
        return rawValue.lightGreen
      case .heart:
        return rawValue.lightRed
      }
    }
  }
}
