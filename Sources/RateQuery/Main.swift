import ArgumentParser
import Foundation
import HMRCExchangeRate

struct RateQuery: AsyncParsableCommand {
  mutating func run() async throws {
    let rates = try await RateSource.directHMRC.rate(of: "TWD", at: Date())
    print(rates)
  }
}

@main
enum App {
  static func main() async throws {
    try await RateQuery.main()
  }
}
