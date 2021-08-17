import Foundation

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
  func fetchRate(of month: Month) async throws -> [Rate.CurrencyCode: [Rate]] {
    let url = try urlForRateXML(of: month)
    let (xmlData, response) = try await urlSession.data(from: url)

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
