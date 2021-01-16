@testable import HMRCExchangeRate
import XCTest

final class RateTests: XCTestCase {
  func testCountryDescription() {
    let country = Country(name: "Taiwan", code: "TW")
    XCTAssertEqual("\(country)", "Taiwan")
  }

  func testCurrencyDescription() {
    let currency = Currency(name: "Dollar", code: "USD")
    XCTAssertEqual("\(currency)", "USD")
  }

  func testRateDescription() {
    guard let rawRate = Decimal(string: "39.84") else {
      XCTFail("Couldn't inititalize Decimal for testing")
      return
    }
    let rate = Rate(country: .init(name: "Taiwan", code: "TW"),
                    currency: .init(name: "Dollar", code: "TWD"),
                    rate: rawRate)
    XCTAssertEqual("\(rate)", "GBP/TWD@39.84")
  }
}
