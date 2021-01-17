import Foundation

typealias Year = Int
typealias Month = Int
typealias CurrencyCode = String

protocol RateFetcher {
  func fetchMonthlyRate(for month: Month, in year: Year) -> [CurrencyCode: Rate]?
}

public class RateSource {
  private var cache = [Year: [Month: [CurrencyCode: Rate]]]()
  private var rateFetcher: RateFetcher

  init(rateFetcher: RateFetcher) {
    self.rateFetcher = rateFetcher
  }

  public func rate(of currencyCode: String, in date: Date) -> Rate? {
    let year = Calendar.current.component(.year, from: date)
    let month = Calendar.current.component(.month, from: date)
    if let monthlyTable = cache[year]?[month] {
      return monthlyTable[currencyCode]
    }
    guard let fetchedValue = rateFetcher.fetchMonthlyRate(for: month, in: year) else {
      return nil
    }
    cache[year, default: [:]][month, default: [:]] = fetchedValue
    return cache[year]?[month]?[currencyCode]
  }
}
