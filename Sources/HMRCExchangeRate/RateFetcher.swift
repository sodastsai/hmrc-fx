import Foundation

protocol RateFetcher {
  func fetchRate(of month: Month) -> [CurrencyCode: [Rate]]?
}

protocol XMLDataRateFetcher: RateFetcher {
  func urlForRateXML(of month: Month) -> URL?
}

extension XMLDataRateFetcher {
  func fetchRate(of month: Month) -> [CurrencyCode: [Rate]]? {
    guard let url = urlForRateXML(of: month) else {
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
    return parseMonthlyRate(from: xmlString, for: month)
  }
}
