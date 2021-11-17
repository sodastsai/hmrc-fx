import Foundation

private let userAgent =
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 " +
  "(KHTML, like Gecko) Version/15.1 Safari/605.1.15"

public protocol RateFetcher {
  func fetchRate(of month: Month) async throws -> [Rate.CurrencyCode: [Rate]]
}

public enum RateFetcherError: Error {
  case invalidURL
  case fetchingError
}

protocol RemoteXMLDataRateFetcher: RateFetcher {
  var urlSession: URLSession { get }
  func urlForRateXML(of month: Month) throws -> URL
}

extension RemoteXMLDataRateFetcher {
  private func urlRequest(of month: Month) throws -> URLRequest {
    let url = try urlForRateXML(of: month)
    var request = URLRequest(url: url)
    request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
    return request
  }

  func fetchRate(of month: Month) async throws -> [Rate.CurrencyCode: [Rate]] {
    let urlRequest = try urlRequest(of: month)
    let (xmlData, response) = try await urlSession.data(for: urlRequest)

    guard
      let httpResponse = response as? HTTPURLResponse,
      httpResponse.statusCode < 400
    else {
      throw RateFetcherError.fetchingError
    }

    let monthlyRate = try MonthlyRate(xmlData: xmlData)
    return monthlyRate.rates
  }
}
