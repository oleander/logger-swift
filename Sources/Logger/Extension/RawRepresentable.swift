extension Printable where Self: RawRepresentable, Self.RawValue: StringProtocol {
  var printable: String {
    return String(rawValue)
  }
}
