import Algorithms
import ArgumentParser
import AsyncAlgorithms
import CodableCSV
import Foundation
import HMRCExchangeRate

enum Error: Swift.Error {
  case tooManyRates(String, Month)
}

@main
struct RateListing: AsyncParsableCommand {
  @Argument(help: "Starting month to query rates, in mm/yyyy format", transform: Month.init(_:))
  var startingMonth: Month

  @Argument(help: "Ending month to query rates, in mm/yyyy format", transform: Month.init(_:))
  var endingMonth: Month

  @Argument(help: "Currency name, like TWD, USD")
  var currencies: [String]

  var months: ClosedRange<Month> {
    startingMonth ... endingMonth
  }

  mutating func run() async throws {
    let data = try await product(currencies, months).async.map { currency, month in
      (currency, month, try await RateSource.directHMRC.rate(of: currency, in: month))
    }.reduce([Month: [String: Decimal]]()) { result, ratesPair in
      let (currency, month, rates) = ratesPair
      guard rates.count == 1, let rate = rates.first else {
        throw Error.tooManyRates(currency, month)
      }
      var newResult = result
      newResult[month, default: [:]][currency] = rate.rate
      return newResult
    }

    let csvRows = [
      ["Month"] + currencies,
    ] + data.sorted { pair1, pair2 in
      let (month1, _) = pair1
      let (month2, _) = pair2
      return month1 < month2
    }.map { month, rates in
      ["\(month)"] + currencies.compactMap { rates[$0] }.map { "\($0)" }
    }
    let csvString = try CSVWriter.encode(rows: csvRows, into: String.self)
    print(csvString)
  }
}
