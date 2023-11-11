import Foundation

struct HMRCRateFetcher: RemoteXMLDataRateFetcher {
  let urlSession = URLSession.shared

  private func string(of month: Month) -> String {
    let yearString = "\(month.year)".suffix(2)
    let monthValue = month.name.rawValue
    let monthString = monthValue < 10 ? "0\(monthValue)" : "\(monthValue)"
    return "\(monthString)\(yearString)"
  }

  private func urlString(of month: Month) -> String {
    switch month {
    case _ where month.year >= 2023:
      "https://www.trade-tariff.service.gov.uk/api/v2/exchange_rates/files/monthly_xml_\(month.year)-\(month.name.rawValue).xml"
    default:
      "http://www.hmrc.gov.uk/softwaredevelopers/rates/exrates-monthly-\(string(of: month)).XML"
    }
  }

  func urlForRateXML(of month: Month) throws -> URL {
    guard let url = URL(string: urlString(of: month)) else {
      throw RateFetcherError.invalidURL
    }
    return url
  }
}

public extension RateSource {
  static let directHMRC = RateSource(rateFetcher: HMRCRateFetcher())
}
