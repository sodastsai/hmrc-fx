import Foundation

public struct Rate {
  public typealias CurrencyCode = String

  public struct Country {
    public let name: String
    public let code: String

    public init(name: String, code: String) {
      self.name = name
      self.code = code
    }
  }

  public struct Currency {
    public let name: String
    public let code: CurrencyCode

    public init(name: String, code: String) {
      self.name = name
      self.code = code
    }
  }

  public let country: Country
  public let currency: Currency
  public let rate: Decimal

  public init(country: Country, currency: Currency, rate: Decimal) {
    self.country = country
    self.currency = currency
    self.rate = rate
  }
}

extension Rate.Country: CustomStringConvertible {
  public var description: String { name }
}

extension Rate.Currency: CustomStringConvertible {
  public var description: String { code }
}

extension Rate: CustomStringConvertible {
  public var description: String {
    "\(currency)/GBP@\(rate)"
  }
}

extension Rate: Decodable {
  private enum CodingKey: String, Swift.CodingKey {
    case countryName
    case countryCode
    case currencyName
    case currencyCode
    case rateNew
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKey.self)
    country = Country(name: try container.decode(String.self, forKey: .countryName),
                      code: try container.decode(String.self, forKey: .countryCode))
    currency = Currency(name: try container.decode(String.self, forKey: .currencyName),
                        code: try container.decode(String.self, forKey: .currencyCode))
    rate = try container.decode(Decimal.self, forKey: .rateNew)
  }
}
