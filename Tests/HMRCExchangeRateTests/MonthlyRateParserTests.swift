import Foundation
@testable import HMRCExchangeRate
import XCTest

final class MonthlyRateParserTests: XCTestCase {
  func testParseMonthlyXML() {
    guard
      let xmlPath = Bundle.module.path(forResource: "MonthlyRateExample", ofType: "xml"),
      let xmlContent = try? String(contentsOfFile: xmlPath, encoding: .utf8)
    else {
      XCTFail("Cannot load example XML")
      return
    }
    let rateList = parseMonthlyRateXml(xmlContent)
    guard rateList.count == 3 else {
      XCTFail("Parsed list has wrong length")
      return
    }
    XCTAssertEqual("\(rateList[0])", "TWD/GBP@39.84")
    XCTAssertEqual("\(rateList[1])", "USD/GBP@1.3284")
    XCTAssertEqual("\(rateList[2])", "EUR/GBP@1.127")

    let twdRate = rateList[0]
    XCTAssertEqual(twdRate.country.name, "Taiwan")
    XCTAssertEqual(twdRate.country.code, "TW")
    XCTAssertEqual(twdRate.currency.name, "Dollar")
    XCTAssertEqual(twdRate.currency.code, "TWD")
    XCTAssertEqual("\(twdRate.rate)", "39.84")
  }
}
