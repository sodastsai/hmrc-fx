import Foundation

private let hmrcFxRateURLDateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "MMyy"
  return formatter
}()

struct HMRCRateFetcher: XMLDataRateFetcher {
  func urlOfMonthlyRateXML(for month: Month, in year: Year) -> URL? {
    guard
      month >= 1,
      month <= 12,
      let date = DateComponents(calendar: .current, year: year, month: month, day: 1).date
    else {
      return nil
    }
    let dateString = hmrcFxRateURLDateFormatter.string(from: date)
    return URL(string: "http://www.hmrc.gov.uk/softwaredevelopers/rates/exrates-monthly-\(dateString).XML")
  }
}

public extension RateSource {
  static let directHMRC = RateSource(rateFetcher: HMRCRateFetcher())
}
