import Foundation

public typealias CurrencyCode = String

public struct Country {
  public let name: String
  public let code: String
}

public struct Currency {
  public let name: String
  public let code: CurrencyCode
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
