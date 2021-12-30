import ArgumentParser
import Foundation
import HMRCExchangeRate

struct RateQuery: AsyncParsableCommand {
  @Argument(help: "Currency name, like TWD, USD")
  var currency: String

  @Argument(help: "Month to query rates, in dd/yyyy format", transform: Month.init(_:))
  var months: [Month]

  mutating func run() async throws {
    for month in months {
      let rates = try await RateSource.directHMRC.rate(of: currency, in: month)
      print("Rates in \(month)")
      printRates(rates)
    }
  }

  private func printRates(_ rates: [Rate]) {
    if rates.count == 1 {
      print(rates[0])
    } else {
      print(rates)
    }
  }
}

@main
enum App {
  static func main() async throws {
    try await RateQuery.main()
  }
}
