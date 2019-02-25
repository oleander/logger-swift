#if os(Linux)
  import Glibc
#else
  import Darwin
#endif
import Foundation

struct StderrOutputStream: TextOutputStream {
  public mutating func write(_ string: String) { fputs(string, stderr) }
}

struct StdoutOutputStream: TextOutputStream {
  public mutating func write(_ string: String) { fputs(string, stdout) }
}
