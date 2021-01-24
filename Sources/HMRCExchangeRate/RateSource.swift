import Foundation

public class RateSource {
  private var cache = [Month: [CurrencyCode: [Rate]]]()
  private let rateFetcher: RateFetcher
  private let urlSession: URLSession

  init(rateFetcher: RateFetcher, urlSession: URLSession = .shared) {
    self.rateFetcher = rateFetcher
    self.urlSession = urlSession
  }

  public func rate(of currencyCode: String, at date: Date) -> [Rate]? {
    rate(of: currencyCode, in: Month(of: date))
  }

  public func rate(of currencyCode: String, in month: Month) -> [Rate]? {
    if let monthlyTable = cache[month] {
      return monthlyTable[currencyCode]
    }
    guard let fetchedValue = rateFetcher.fetchRate(of: month, using: urlSession) else {
      return nil
    }
    cache[month, default: [:]] = fetchedValue
    return cache[month]?[currencyCode]
  }
}
