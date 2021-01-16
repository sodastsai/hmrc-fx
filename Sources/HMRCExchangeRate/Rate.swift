import Foundation

public struct Country {
  public let name: String
  public let code: String
}

public struct Currency {
  public let name: String
  public let code: String
}

public struct Rate {
  public let country: Country
  public let currency: Currency
  public let rate: Decimal
}

extension Country: CustomStringConvertible {
  public var description: String { name }
}

extension Currency: CustomStringConvertible {
  public var description: String { code }
}

extension Rate: CustomStringConvertible {
  public var description: String {
    "GBP/\(currency)@\(rate)"
  }
}
