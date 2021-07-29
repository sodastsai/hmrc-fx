import Foundation
@testable import HMRCExchangeRate
import XCTest

class MockRateFetcher: RateFetcher {
  var fetchingCount = [Month: Int]()
  var rate: Decimal?

  func fetchRate(of month: Month) throws -> [Rate.CurrencyCode: [Rate]] {
    fetchingCount[month, default: 0] += 1
    guard let rate = rate else {
      throw RateFetcherError.fetchingError
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
    do {
      let rates = try source.rate(of: "TWD", at: .dateBy(day: 10, of: Month(.aug, in: 2018)))
      guard let rate1 = rates.first else {
        XCTFail("Failed to fetch rate")
        return
      }
      XCTAssertEqual(rate1.currency.code, "TWD")
      XCTAssertEqual(rate1.rate, 40)
    } catch {
      XCTFail("Failed to fetch rate")
    }
    // fetch again to check caching behavior
    XCTAssertNoThrow(try source.rate(of: "TWD", at: .dateBy(day: 10, of: Month(.aug, in: 2018))))
    // fetch another to check caching behavior
    fetcher.rate = 38
    do {
      let rates = try source.rate(of: "TWD", at: .dateBy(day: 10, of: Month(.sep, in: 2018)))
      guard let rate2 = rates.first else {
        XCTFail("Failed to fetch rate")
        return
      }
      XCTAssertEqual(rate2.rate, 38)
    } catch {
      XCTFail("Failed to fetch rate")
    }
    // fetch non exist
    fetcher.rate = nil
    XCTAssertThrowsError(try source.rate(of: "TWD", at: .dateBy(day: 10, of: Month(.oct, in: 2018)))) { error in
      XCTAssertEqual(error as? RateFetcherError, RateFetcherError.fetchingError)
    }
    XCTAssertThrowsError(try source.rate(of: "TWD", at: .dateBy(day: 10, of: Month(.oct, in: 2018))))

    XCTAssertEqual(fetcher.fetchingCount[Month(.aug, in: 2018)], 1)
    XCTAssertEqual(fetcher.fetchingCount[Month(.sep, in: 2018)], 1)
    XCTAssertEqual(fetcher.fetchingCount[Month(.oct, in: 2018)], 2)
  }
}
