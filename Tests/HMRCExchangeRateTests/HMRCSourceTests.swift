@testable import HMRCExchangeRate
import XCTest

final class HMRCSourceTests: XCTestCase {
  func testBuildingURL() {
    let fetcher = HMRCRateFetcher()
    XCTAssertEqual(
      fetcher.urlForRateXML(of: Month(.jan, in: 2021))?.absoluteString,
      "http://www.hmrc.gov.uk/softwaredevelopers/rates/exrates-monthly-0121.XML"
    )
  }
}
