import Foundation

public protocol RateFetcher {
  func fetchRate(of month: Month) throws -> [Rate.CurrencyCode: [Rate]]
}

enum RateFetcherError: Error {
  case invalidURL
  case fetchingTimeout
  case fetchingError
}

protocol RemoteXMLDataRateFetcher: RateFetcher {
  var urlSession: URLSession { get }
  func urlForRateXML(of month: Month) throws -> URL
}

extension RemoteXMLDataRateFetcher {
  func fetchRate(of month: Month) throws -> [Rate.CurrencyCode: [Rate]] {
    let url = try urlForRateXML(of: month)

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

    guard dispatchGroup.wait(timeout: .now() + 10) == .success else {
      throw RateFetcherError.fetchingTimeout
    }
    guard let xmlData = pendingXMLData else {
      throw RateFetcherError.fetchingError
    }
    let monthlyRate = try MonthlyRate(xmlData: xmlData)
    return monthlyRate.rates
  }
}
