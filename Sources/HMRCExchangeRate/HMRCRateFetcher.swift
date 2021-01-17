import Foundation

struct HMRCRateFetcher: XMLDataRateFetcher {
  private func string(of month: Month) -> String {
    let yearString = "\(month.year)".suffix(2)
    let monthValue = month.name.rawValue
    let monthString = monthValue < 10 ? "0\(monthValue)" : "\(monthValue)"
    return "\(monthString)\(yearString)"
  }

  func urlForRateXML(of month: Month) -> URL? {
    URL(string: "http://www.hmrc.gov.uk/softwaredevelopers/rates/exrates-monthly-\(string(of: month)).XML")
  }
}

public extension RateSource {
  static let directHMRC = RateSource(rateFetcher: HMRCRateFetcher())
}
