import Foundation
@testable import HMRCExchangeRate
import XCTest

class MockRateFetcher: RateFetcher {
  var fetchingCount = [Year: [Month: Int]]()
  var rate: Decimal?

  func fetchMonthlyRate(for month: Month, in year: Year) -> [CurrencyCode: Rate]? {
    fetchingCount[year, default: [:]][month, default: 0] += 1
    guard let rate = rate else {
      return nil
    }
    return ["TWD": Rate(country: .init(name: "Taiwan", code: "TW"),
                        currency: .init(name: "Dollar", code: "TWD"),
                        rate: rate)]
  }
}

extension Date {
  static func dateBy(day: Int, month: Month, year: Year) -> Date {
    guard let date = DateComponents(calendar: .current, year: year, month: month, day: day).date else {
      fatalError("Failed to create date")
    }
    return date
  }
}

final class RateSourceTests: XCTestCase {
  func testFetchCachingBehavior() {
    let fetcher = MockRateFetcher()
    let source = RateSource(rateFetcher: fetcher)

    fetcher.rate = 40
    guard let rate1 = source.rate(of: "TWD", in: .dateBy(day: 10, month: 8, year: 2018)) else {
      XCTFail("Failed to fetch rate")
      return
    }
    // fetch again to check caching behavior
    guard source.rate(of: "TWD", in: .dateBy(day: 10, month: 8, year: 2018)) != nil else {
      XCTFail("Failed to fetch rate")
      return
    }
    // fetch another to check caching behavior
    fetcher.rate = 38
    guard let rate2 = source.rate(of: "TWD", in: .dateBy(day: 10, month: 9, year: 2018)) else {
      XCTFail("Failed to fetch rate")
      return
    }
    // fetch non exist
    fetcher.rate = nil
    let rate3 = source.rate(of: "TWD", in: .dateBy(day: 10, month: 10, year: 2018))
    _ = source.rate(of: "TWD", in: .dateBy(day: 10, month: 10, year: 2018))

    XCTAssertEqual(fetcher.fetchingCount[2018]?[8], 1)
    XCTAssertEqual(fetcher.fetchingCount[2018]?[9], 1)
    XCTAssertEqual(fetcher.fetchingCount[2018]?[10], 2)

    XCTAssertEqual(rate1.currency.code, "TWD")
    XCTAssertEqual(rate1.rate, 40)
    XCTAssertEqual(rate2.rate, 38)
    XCTAssertNil(rate3)
  }
}
