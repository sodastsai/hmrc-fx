import Foundation
import SWXMLHash

struct MonthlyRate {
  let year: Int
  let month: Int
  let rates: [Rate]
}

func parseMonthlyRateXml(_ xmlContent: String) -> MonthlyRate? {
  let xml = SWXMLHash.parse(xmlContent)
  guard
    let xmlRootList = xml["exchangeRateMonthList"].all.first,
    let period = xmlRootList.element?.attribute(by: "Period")?.text,
    let dateRange = parseRepresentingMonth(from: period)
  else {
    return nil
  }
  let rates = xmlRootList.children.compactMap { Rate(xmlIndexer: $0) }
  return MonthlyRate(year: dateRange.year, month: dateRange.month, rates: rates)
}

private let periodDateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "dd/MMM/yyyy"
  return formatter
}()

private func parseRepresentingMonth(from period: String) -> (year: Int, month: Int)? {
  let components = period.split(separator: " ")
  guard
    components.count == 3,
    let beginDate = periodDateFormatter.date(from: String(components[0])),
    let endDate = periodDateFormatter.date(from: String(components[2]))
  else { return nil }

  let calendar = Calendar.current
  let beginYear = calendar.component(.year, from: beginDate)
  let endYear = calendar.component(.year, from: endDate)
  let beginMonth = calendar.component(.month, from: beginDate)
  let endMonth = calendar.component(.month, from: endDate)

  guard beginYear == endYear, beginMonth == endMonth else { return nil }
  return (year: beginYear, month: beginMonth)
}

private extension Rate {
  init?(xmlIndexer: XMLIndexer) {
    guard
      xmlIndexer.element?.name == "exchangeRate",
      let countryName = xmlIndexer["countryName"].element?.text,
      let countryCode = xmlIndexer["countryCode"].element?.text,
      let currencyName = xmlIndexer["currencyName"].element?.text,
      let currencyCode = xmlIndexer["currencyCode"].element?.text,
      let rateString = xmlIndexer["rateNew"].element?.text,
      let rate = Decimal(string: rateString)
    else {
      return nil
    }
    self = .init(
      country: .init(name: countryName, code: countryCode),
      currency: .init(name: currencyName, code: currencyCode),
      rate: rate
    )
  }
}
