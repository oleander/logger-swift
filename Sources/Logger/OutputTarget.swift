// https://raw.githubusercontent.com/onevcat/Rainbow/master/Sources/OutputTarget.swift
#if os(Linux) || CYGWIN
import Glibc
#else
import Darwin.C
#endif

public func getEnvValue(_ key: String) -> String? {
    guard let value = getenv(key) else {
        return nil
    }
    return String(cString: value)
}


///
/**
Output target of Rainbow.

- Unknown: Unknown target.
- Console: A valid console is detected connected.
- XcodeColors: Used in Xcode with XcodeColors enabled.
*/
public enum OutputTarget {
    case unknown
    case console
    case xcodeColors

    /// Detected output target by current envrionment.
    static var current: OutputTarget = {
        // Check if Xcode Colors is installed and enabled.
        let xcodeColorsEnabled = (getEnvValue("XcodeColors") == "YES")
        if xcodeColorsEnabled {
            return .xcodeColors
        }

        // Check if we are in any term env and the output is a tty.
        let termType = getEnvValue("TERM")
        if let t = termType, t.lowercased() != "dumb" && isatty(fileno(stdout)) != 0 {
            return .console
        }

        return .unknown
    }()
}
