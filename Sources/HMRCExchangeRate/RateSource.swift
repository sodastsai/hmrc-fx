import Foundation

public class RateSource {
  private var cache = [Month: [Rate.CurrencyCode: [Rate]]]()
  private let rateFetcher: RateFetcher

  public enum Error: Swift.Error {
    case unknownCurrencyCode
  }

  public init(rateFetcher: RateFetcher) {
    self.rateFetcher = rateFetcher
  }

  public func rate(of currencyCode: String, at date: Date) async throws -> [Rate] {
    try await rate(of: currencyCode, in: Month(of: date))
  }

  public func rate(of currencyCode: String, in month: Month) async throws -> [Rate] {
    if let monthlyTable = cache[month], let cachedRate = monthlyTable[currencyCode] {
      return cachedRate
    }

    let fetchedValue = try await rateFetcher.fetchRate(of: month)
    cache[month, default: [:]] = fetchedValue

    guard let rates = fetchedValue[currencyCode] else {
      throw RateSource.Error.unknownCurrencyCode
    }
    return rates
  }
}
