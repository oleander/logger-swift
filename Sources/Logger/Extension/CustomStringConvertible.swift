extension Printable where Self: CustomStringConvertible {
  var printable: String {
    return description
  }
}

extension CustomStringConvertible {
  public var hl: String {
    return String(describing: self).hl
  }
}
