import Foundation
import HMRCExchangeRate

@main
enum DemoApp {
  static func main() async throws {
    let rates = try await RateSource.directHMRC.rate(of: "TWD", at: Date())
    print(rates)
  }
}
