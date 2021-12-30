@testable import HMRCExchangeRate
import XCTest

final class MonthTests: XCTestCase {
  func testDescription() {
    XCTAssertEqual("\(Month(.jan, in: 2020))", "1/2020")
    XCTAssertEqual("\(Month(.feb, in: 2020))", "2/2020")
    XCTAssertEqual("\(Month(.mar, in: 2020))", "3/2020")
    XCTAssertEqual("\(Month(.apr, in: 2020))", "4/2020")
    XCTAssertEqual("\(Month(.may, in: 2021))", "5/2021")
    XCTAssertEqual("\(Month(.jun, in: 2020))", "6/2020")
    XCTAssertEqual("\(Month(.jul, in: 2020))", "7/2020")
    XCTAssertEqual("\(Month(.aug, in: 2020))", "8/2020")
    XCTAssertEqual("\(Month(.sep, in: 2007))", "9/2007")
    XCTAssertEqual("\(Month(.oct, in: 2020))", "10/2020")
    XCTAssertEqual("\(Month(.nov, in: 2020))", "11/2020")
    XCTAssertEqual("\(Month(.dec, in: 2020))", "12/2020")
  }

  func testEquatable() {
    XCTAssertEqual(Month(.jan, in: 2020), Month(.jan, in: 2020))
    XCTAssertNotEqual(Month(.jan, in: 2020), Month(.jan, in: 2021))
    XCTAssertNotEqual(Month(.jan, in: 2020), Month(.apr, in: 2020))
    XCTAssertNotEqual(Month(.jan, in: 2020), Month(.apr, in: 2021))
  }

  func testComparable() {
    XCTAssertLessThan(Month(.jan, in: 2020), Month(.feb, in: 2020))
    XCTAssertLessThan(Month(.jan, in: 2020), Month(.jan, in: 2021))
    XCTAssertFalse(Month(.jan, in: 2020) < Month(.feb, in: 2019))
    XCTAssertFalse(Month(.feb, in: 2020) < Month(.jan, in: 2020))
  }

  func testStrideable_distance() {
    XCTAssertEqual(Month(.jan, in: 2020).distance(to: Month(.apr, in: 2021)), 15)
    XCTAssertEqual(Month(.jan, in: 2020).distance(to: Month(.feb, in: 2020)), 1)
    XCTAssertEqual(Month(.apr, in: 2020).distance(to: Month(.apr, in: 2020)), 0)
    XCTAssertEqual(Month(.apr, in: 2020).distance(to: Month(.feb, in: 2020)), -2)
    XCTAssertEqual(Month(.apr, in: 2021).distance(to: Month(.feb, in: 2020)), -14)
  }

  func testStrideable_advance() {
    XCTAssertEqual(Month(.jan, in: 2020).advanced(by: 3), Month(.apr, in: 2020))
    XCTAssertEqual(Month(.jan, in: 2020).advanced(by: 12), Month(.jan, in: 2021))
    XCTAssertEqual(Month(.jan, in: 2020).advanced(by: 25), Month(.feb, in: 2022))
    XCTAssertEqual(Month(.may, in: 2020).advanced(by: -1), Month(.apr, in: 2020))
    XCTAssertEqual(Month(.jan, in: 2020).advanced(by: -3), Month(.oct, in: 2019))
    XCTAssertEqual(Month(.jan, in: 2020).advanced(by: -15), Month(.oct, in: 2018))
  }

  func testRange() {
    XCTAssertEqual(Array(Month(.jan, in: 2020) ..< Month(.apr, in: 2021)), [
      Month(.jan, in: 2020),
      Month(.feb, in: 2020),
      Month(.mar, in: 2020),
      Month(.apr, in: 2020),
      Month(.may, in: 2020),
      Month(.jun, in: 2020),
      Month(.jul, in: 2020),
      Month(.aug, in: 2020),
      Month(.sep, in: 2020),
      Month(.oct, in: 2020),
      Month(.nov, in: 2020),
      Month(.dec, in: 2020),
      Month(.jan, in: 2021),
      Month(.feb, in: 2021),
      Month(.mar, in: 2021),
    ])
  }

  func testMonthNameStringLiteral() {
    XCTAssertEqual(Month.Name(rawValue: "Jan"), .jan)
    XCTAssertEqual(Month.Name(rawValue: "Feb"), .feb)
    XCTAssertEqual(Month.Name(rawValue: "Mar"), .mar)
    XCTAssertEqual(Month.Name(rawValue: "Apr"), .apr)
    XCTAssertEqual(Month.Name(rawValue: "May"), .may)
    XCTAssertEqual(Month.Name(rawValue: "Jun"), .jun)
    XCTAssertEqual(Month.Name(rawValue: "Jul"), .jul)
    XCTAssertEqual(Month.Name(rawValue: "Aug"), .aug)
    XCTAssertEqual(Month.Name(rawValue: "Sep"), .sep)
    XCTAssertEqual(Month.Name(rawValue: "Oct"), .oct)
    XCTAssertEqual(Month.Name(rawValue: "Nov"), .nov)
    XCTAssertEqual(Month.Name(rawValue: "Dec"), .dec)

    XCTAssertEqual(Month.Name(rawValue: "January"), .jan)
    XCTAssertEqual(Month.Name(rawValue: "February"), .feb)
    XCTAssertEqual(Month.Name(rawValue: "March"), .mar)
    XCTAssertEqual(Month.Name(rawValue: "April"), .apr)
    XCTAssertEqual(Month.Name(rawValue: "May"), .may)
    XCTAssertEqual(Month.Name(rawValue: "June"), .jun)
    XCTAssertEqual(Month.Name(rawValue: "July"), .jul)
    XCTAssertEqual(Month.Name(rawValue: "August"), .aug)
    XCTAssertEqual(Month.Name(rawValue: "September"), .sep)
    XCTAssertEqual(Month.Name(rawValue: "October"), .oct)
    XCTAssertEqual(Month.Name(rawValue: "November"), .nov)
    XCTAssertEqual(Month.Name(rawValue: "December"), .dec)

    XCTAssertNil(Month.Name(rawValue: "Blah"))
  }

  func testMonthStringLiteral() throws {
    XCTAssertEqual(try Month("1/2021"), Month(.jan, in: 2021))
    XCTAssertEqual(try Month("04/1992"), Month(.apr, in: 1992))
    XCTAssertEqual(try Month("11/2021"), Month(.nov, in: 2021))
    XCTAssertEqual(try Month("Dec 2022"), Month(.dec, in: 2022))
    XCTAssertEqual(try Month("July 2020"), Month(.jul, in: 2020))
  }

  func testMonthStringLiteralWithUnknownPattern() {
    XCTAssertThrowsError(try Month("Jan,2021")) { error in
      guard case let Month.Error.unknownStringRepresentation(errorString) = error else {
        XCTFail("Unknown error: \(error)")
        return
      }
      XCTAssertEqual(errorString, "Jan,2021")
    }
  }

  func testMonthStringLiteralWithUnknownMonthString() {
    XCTAssertThrowsError(try Month("15/2021")) { error in
      guard case let Month.Error.unknownMonth(errorString) = error else {
        XCTFail("Unknown error: \(error)")
        return
      }
      XCTAssertEqual(errorString, "15")
    }
  }
}
