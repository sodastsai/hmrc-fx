import Foundation

public protocol RateFetcher {
  func fetchRate(of month: Month) -> [CurrencyCode: [Rate]]?
}

protocol RemoteXMLDataRateFetcher: RateFetcher {
  var urlSession: URLSession { get }
  func urlForRateXML(of month: Month) -> URL?
}

extension RemoteXMLDataRateFetcher {
  func fetchRate(of month: Month) -> [CurrencyCode: [Rate]]? {
    guard let url = urlForRateXML(of: month) else {
      return nil
    }
    var pendingXMLData: Data?
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    urlSession.dataTask(with: url) { data, response, error in
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
      let xmlData = pendingXMLData
    else {
      return nil
    }
    return MonthlyRate(xmlData: xmlData)?.rates
  }
}
