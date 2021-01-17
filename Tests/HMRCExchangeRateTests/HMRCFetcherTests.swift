@testable import HMRCExchangeRate
import XCTest

final class HMRCFetcherTests: XCTestCase {
  func testBuildingURL() {
    XCTAssertEqual(
      HMRCFetcher().url(for: 1, in: 2021)?.absoluteString,
      "http://www.hmrc.gov.uk/softwaredevelopers/rates/exrates-monthly-0121.XML"
    )
    XCTAssertNil(HMRCFetcher().url(for: 13, in: 2021))
  }
}
