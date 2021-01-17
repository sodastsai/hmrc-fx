import Foundation

private let hmrcFxRateURLDateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "MMyy"
  return formatter
}()

struct HMRCFetcher: RateFetcher {
  func url(for month: Month, in year: Year) -> URL? {
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

  func fetchMonthlyRate(for month: Month, in year: Year) -> [CurrencyCode: [Rate]]? {
    guard let url = url(for: month, in: year) else {
      return nil
    }
    var pendingXmlString: String?
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    URLSession.shared.dataTask(with: url) { data, response, error in
      defer {
        dispatchGroup.leave()
      }
      guard
        let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode < 400,
        error == nil,
        let xmlData = data
      else {
        return
      }
      pendingXmlString = String(data: xmlData, encoding: .utf8)
    }.resume()

    guard
      dispatchGroup.wait(timeout: .now() + 10) == .success,
      let xmlString = pendingXmlString,
      let fetchedResult = parseMonthlyRateXml(xmlString),
      fetchedResult.year == year,
      fetchedResult.month == month
    else {
      return nil
    }
    return fetchedResult.rates
  }
}

public extension RateSource {
  static let directHMRC = RateSource(rateFetcher: HMRCFetcher())
}
