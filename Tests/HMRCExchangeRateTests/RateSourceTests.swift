import Foundation
@testable import HMRCExchangeRate
import XCTest

class MockRateFetcher: RateFetcher {
  var fetchingCount = [Month: Int]()
  var rate: Decimal?

  func fetchRate(of month: Month) -> [CurrencyCode: [Rate]]? {
    fetchingCount[month, default: 0] += 1
    guard let rate = rate else {
      return nil
    }
    return ["TWD": [Rate(country: .init(name: "Taiwan", code: "TW"),
                         currency: .init(name: "Dollar", code: "TWD"),
                         rate: rate)]]
  }
}

extension Date {
  static func dateBy(day: Int, of month: Month) -> Date {
    guard
      let date = DateComponents(calendar: .current, year: month.year, month: month.name.rawValue, day: day).date
    else {
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
    guard let rate1 = source.rate(of: "TWD", at: .dateBy(day: 10, of: Month(.aug, in: 2018)))?.first else {
      XCTFail("Failed to fetch rate")
      return
    }
    // fetch again to check caching behavior
    guard source.rate(of: "TWD", at: .dateBy(day: 10, of: Month(.aug, in: 2018))) != nil else {
      XCTFail("Failed to fetch rate")
      return
    }
    // fetch another to check caching behavior
    fetcher.rate = 38
    guard let rate2 = source.rate(of: "TWD", at: .dateBy(day: 10, of: Month(.sep, in: 2018)))?.first else {
      XCTFail("Failed to fetch rate")
      return
    }
    // fetch non exist
    fetcher.rate = nil
    let rate3 = source.rate(of: "TWD", at: .dateBy(day: 10, of: Month(.oct, in: 2018)))?.first
    _ = source.rate(of: "TWD", at: .dateBy(day: 10, of: Month(.oct, in: 2018)))

    XCTAssertEqual(fetcher.fetchingCount[Month(.aug, in: 2018)], 1)
    XCTAssertEqual(fetcher.fetchingCount[Month(.sep, in: 2018)], 1)
    XCTAssertEqual(fetcher.fetchingCount[Month(.oct, in: 2018)], 2)

    XCTAssertEqual(rate1.currency.code, "TWD")
    XCTAssertEqual(rate1.rate, 40)
    XCTAssertEqual(rate2.rate, 38)
    XCTAssertNil(rate3)
  }
}
