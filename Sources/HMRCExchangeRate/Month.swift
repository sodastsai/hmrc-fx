import Foundation

public struct Month {
  public enum Name: Int, RawRepresentable {
    case jan = 1, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
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
}

public extension Month.Name {
  init?(rawValue: String) {
    if let intValue = Int(rawValue) {
      self.init(rawValue: intValue)
    } else if let monthIndex = Calendar.current.monthSymbols.firstIndex(of: rawValue) {
      self.init(rawValue: monthIndex + 1)
    } else if let monthIndex = Calendar.current.shortMonthSymbols.firstIndex(of: rawValue) {
      self.init(rawValue: monthIndex + 1)
    } else {
      return nil
    }
  }
}
