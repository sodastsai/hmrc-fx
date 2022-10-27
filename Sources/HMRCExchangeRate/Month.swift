import Foundation
import Regex

public struct Month {
  public enum Name: Int, RawRepresentable {
    case jan = 1, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
  }

  public enum Error: Swift.Error {
    case unknownStringRepresentation(String)
    case unknownMonth(String)
    case unknownYear(String)
  }

  public let year: Int
  public let name: Name

  public init(_ name: Name, in year: Int) {
    self.name = name
    self.year = year
  }
}

extension Month: CustomStringConvertible {
  public var description: String {
    "\(name.rawValue)/\(year)"
  }
}

extension Month: Comparable {}

extension Month.Name: Comparable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue == rhs.rawValue
  }

  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension Month: Strideable {
  public func distance(to other: Month) -> Int {
    let monthDistance = other.name.rawValue - name.rawValue
    let yearDistance = other.year - year
    return yearDistance * 12 + monthDistance
  }

  public func advanced(by step: Int) -> Month {
    let newMonthValue = year * 12 + name.rawValue - 1 + step
    guard let newName = Name(rawValue: (newMonthValue % 12) + 1) else {
      fatalError("get invalid RawValue: \(newMonthValue)")
    }
    let newYear = newMonthValue / 12
    return Month(newName, in: newYear)
  }
}

extension Month: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(year)
  }
}

public extension Month {
  init(of date: Date) {
    let year = Calendar.current.component(.year, from: date)
    let month = Calendar.current.component(.month, from: date)
    guard let name = Name(rawValue: month) else {
      fatalError("Unknown month value: \(month)")
    }
    self = .init(name, in: year)
  }

  static var current: Month {
    .init(of: Date())
  }

  private static let stringPatterns = [
    Regex(#"^(?<month>\d{1,2})/(?<year>\d{4})$"#),
    Regex(#"^(?<month>[A-Z][a-z]+) (?<year>\d{4})$"#),
  ]

  init(_ string: String) throws {
    for pattern in Self.stringPatterns {
      if let month = try Month(string, with: pattern) {
        self = month
        return
      }
    }
    throw Month.Error.unknownStringRepresentation(string)
  }

  private init?(_ string: String, with pattern: Regex) throws {
    guard let match = pattern.firstMatch(in: string),
          let yearString = match.group(named: "year")?.value,
          let monthString = match.group(named: "month")?.value
    else {
      return nil
    }

    guard let month = Month.Name(rawValue: monthString) else {
      throw Month.Error.unknownMonth(monthString)
    }
    guard let year = Int(yearString) else {
      throw Month.Error.unknownYear(yearString)
    }

    self.init(month, in: year)
  }
}

public extension Month.Name {
  private static let monthShortNames = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  ]
  private static let monthLongNames = [
    "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November",
    "December",
  ]

  init?(rawValue: String) {
    if let intValue = Int(rawValue) {
      self.init(rawValue: intValue)
    } else if let monthIndex = Calendar.current.monthSymbols.firstIndex(of: rawValue) {
      self.init(rawValue: monthIndex + 1)
    } else if let monthIndex = Self.monthShortNames.firstIndex(of: rawValue) {
      self.init(rawValue: monthIndex + 1)
    } else if let monthIndex = Self.monthLongNames.firstIndex(of: rawValue) {
      self.init(rawValue: monthIndex + 1)
    } else {
      return nil
    }
  }
}
