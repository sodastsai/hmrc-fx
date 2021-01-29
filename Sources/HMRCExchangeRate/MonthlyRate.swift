import Foundation
import XMLCoder

struct MonthlyRate {
  let month: Month
  let rates: [CurrencyCode: [Rate]]
}

extension MonthlyRate: Decodable {
  enum DecodingError: Error {
    case invalidPeriodAttribute
  }

  private enum CodingKey: String, Swift.CodingKey {
    case period = "Period"
    case rates = "exchangeRate"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKey.self)
    let periodString = try container.decode(String.self, forKey: .period)
    guard let representingMonth = parseRepresentingMonth(from: periodString) else {
      throw DecodingError.invalidPeriodAttribute
    }
    month = representingMonth
    rates = Dictionary(grouping: try container.decode([Rate].self, forKey: .rates)) {
      $0.currency.code
    }
  }
}

extension MonthlyRate {
  init?(contentsOf url: URL) {
    guard
      let xmlData = try? Data(contentsOf: url),
      let decoded = Self(xmlData: xmlData)
    else {
      return nil
    }
    self = decoded
  }

  init?(xmlData: Data) {
    let decoder = XMLDecoder()
    guard let decoded = try? decoder.decode(Self.self, from: xmlData) else {
      return nil
    }
    self = decoded
  }
}

private let periodDateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "dd/MMM/yyyy"
  return formatter
}()

private func parseRepresentingMonth(from period: String) -> Month? {
  let components = period.split(separator: " ")
  guard
    components.count == 3,
    let beginDate = periodDateFormatter.date(from: String(components[0])),
    let endDate = periodDateFormatter.date(from: String(components[2]))
  else { return nil }

  let beginMonth = Month(of: beginDate)
  let endMonth = Month(of: endDate)
  guard beginMonth == endMonth else { return nil }
  return beginMonth
}
