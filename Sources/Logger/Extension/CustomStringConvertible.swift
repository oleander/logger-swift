extension Printable where Self: CustomStringConvertible {
  var printable: String {
    return description
  }
}
