import Foundation
import XMLCoder

struct MonthlyRate {
  let month: Month
  let rates: [Rate.CurrencyCode: [Rate]]
}

extension MonthlyRate: Decodable {
  enum DecodingError: Error {
    case invalidPeriodAttribute(String)
  }

  private enum CodingKey: String, Swift.CodingKey {
    case period = "Period"
    case rates = "exchangeRate"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKey.self)
    let periodString = try container.decode(String.self, forKey: .period)
    guard let representingMonth = parseRepresentingMonth(from: periodString) else {
      throw DecodingError.invalidPeriodAttribute(periodString)
    }
    month = representingMonth
    rates = Dictionary(grouping: try container.decode([Rate].self, forKey: .rates), by: \.currency.code)
  }
}

extension MonthlyRate {
  init(contentsOf url: URL) throws {
    let xmlData = try Data(contentsOf: url)
    self = try Self(xmlData: xmlData)
  }

  init(xmlData: Data) throws {
    let decoder = XMLDecoder()
    self = try decoder.decode(Self.self, from: xmlData)
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
