import Foundation
@testable import HMRCExchangeRate
import XCTest

final class MonthlyRateParserTests: XCTestCase {
  func testParseMonthlyXML1() {
    guard
      let xmlPath = Bundle.module.path(forResource: "MonthlyRateExample1", ofType: "xml")
    else {
      XCTFail("Cannot load example XML")
      return
    }
    guard let monthlyRate = try? MonthlyRate(contentsOf: URL(fileURLWithPath: xmlPath)) else {
      XCTFail("Failed to parse XML")
      return
    }
    guard
      monthlyRate.rates.count == 3,
      let twdRate = monthlyRate.rates["TWD"]?.first,
      let usdRate = monthlyRate.rates["USD"]?.first,
      let eurRate = monthlyRate.rates["EUR"]?.first
    else {
      XCTFail("Parsed list has wrong length")
      return
    }

    XCTAssertEqual(monthlyRate.month, Month(.dec, in: 2017))

    XCTAssertEqual("\(twdRate)", "TWD/GBP@39.84")
    XCTAssertEqual("\(usdRate)", "USD/GBP@1.3284")
    XCTAssertEqual("\(eurRate)", "EUR/GBP@1.127")

    XCTAssertEqual(twdRate.country.name, "Taiwan")
    XCTAssertEqual(twdRate.country.code, "TW")
    XCTAssertEqual(twdRate.currency.name, "Dollar")
    XCTAssertEqual(twdRate.currency.code, "TWD")
    XCTAssertEqual("\(twdRate.rate)", "39.84")
  }

  func testParseMonthlyXML2() {
    guard
      let xmlPath = Bundle.module.path(forResource: "MonthlyRateExample2", ofType: "xml")
    else {
      XCTFail("Cannot load example XML")
      return
    }
    guard let monthlyRate = try? MonthlyRate(contentsOf: URL(fileURLWithPath: xmlPath)) else {
      XCTFail("Failed to parse XML")
      return
    }
    XCTAssertEqual(monthlyRate.month, Month(.sep, in: 2019))
  }
}
