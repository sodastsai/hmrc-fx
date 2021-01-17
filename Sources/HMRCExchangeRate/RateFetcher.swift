import Foundation

protocol RateFetcher {
  func fetchMonthlyRate(for month: Month, in year: Year) -> [CurrencyCode: [Rate]]?
}

protocol XMLDataRateFetcher: RateFetcher {
  func urlOfMonthlyRateXML(for month: Month, in year: Year) -> URL?
}

extension XMLDataRateFetcher {
  func fetchMonthlyRate(for month: Month, in year: Year) -> [CurrencyCode: [Rate]]? {
    guard let url = urlOfMonthlyRateXML(for: month, in: year) else {
      return nil
    }
    var pendingXMLData: Data?
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    URLSession.shared.dataTask(with: url) { data, response, error in
      defer {
        dispatchGroup.leave()
      }
      guard
        let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode < 400,
        error == nil
      else {
        return
      }
      pendingXMLData = data
    }.resume()

    guard
      dispatchGroup.wait(timeout: .now() + 10) == .success,
      let xmlData = pendingXMLData,
      let xmlString = String(data: xmlData, encoding: .utf8)
    else {
      return nil
    }
    return parseMonthlyRate(from: xmlString, for: month, in: year)
  }
}
