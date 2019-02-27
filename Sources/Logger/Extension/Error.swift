extension Printable where Self: Error {
  var printable: String {
    return localizedDescription
  }
}
