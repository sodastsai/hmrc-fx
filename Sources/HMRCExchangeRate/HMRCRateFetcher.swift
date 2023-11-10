import Foundation

struct HMRCRateFetcher: RemoteXMLDataRateFetcher {
  let urlSession = URLSession.shared

  private func string(of month: Month) -> String {
    let yearString = "\(month.year)".suffix(2)
    let monthValue = month.name.rawValue
    let monthString = monthValue < 10 ? "0\(monthValue)" : "\(monthValue)"
    return "\(monthString)\(yearString)"
  }

  func urlForRateXML(of month: Month) throws -> URL {
    let urlString = switch month {
    case _ where month.year >= 2023:
      "https://www.trade-tariff.service.gov.uk/api/v2/exchange_rates/files/monthly_xml_\(month.year)-\(month.name.rawValue).xml"
    default:
      "http://www.hmrc.gov.uk/softwaredevelopers/rates/exrates-monthly-\(string(of: month)).XML"
    }
    guard let url = URL(string: urlString) else {
      throw RateFetcherError.invalidURL
    }
    return url
  }
}

public extension RateSource {
  static let directHMRC = RateSource(rateFetcher: HMRCRateFetcher())
}
