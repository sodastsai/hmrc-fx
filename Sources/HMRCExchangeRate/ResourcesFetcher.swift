import Foundation

var allResources = [Year: [Month: URL]]()

public protocol ResourcesLoader {
  static var resources: [URL] { get }
}

public func register(resourcesLoader: ResourcesLoader.Type) {
  for url in resourcesLoader.resources {
    guard url.pathExtension == "xml" else {
      continue
    }
    let components = url.deletingPathExtension().lastPathComponent.split(separator: "-")
    guard
      components.count == 2,
      let month = Int(components[0]),
      let year = Int(components[1])
    else {
      continue
    }
    allResources[year, default: [:]][month] = url
  }
}

class ResourcesFetcher: RateFetcher {
  func fetchMonthlyRate(for month: Month, in year: Year) -> [CurrencyCode: [Rate]]? {
    guard
      let url = allResources[year]?[month],
      let xmlString = try? String(contentsOf: url, encoding: .utf8)
    else {
      return nil
    }
    return parseMonthlyRate(from: xmlString, for: month, in: year)
  }
}

public extension RateSource {
  static let bundled = RateSource(rateFetcher: ResourcesFetcher())
}
