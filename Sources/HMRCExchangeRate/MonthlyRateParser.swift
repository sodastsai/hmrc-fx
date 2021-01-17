import Foundation
import SWXMLHash

struct MonthlyRate {
  let month: Month
  let rates: [CurrencyCode: [Rate]]
}

func parseMonthlyRate(from xmlString: String, for month: Month) -> [CurrencyCode: [Rate]]? {
  guard
    let monthlyRate = parseMonthlyRateXml(xmlString),
    monthlyRate.month == month
  else {
    return nil
  }
  return monthlyRate.rates
}

func parseMonthlyRateXml(_ xmlContent: String) -> MonthlyRate? {
  let xml = SWXMLHash.parse(xmlContent)
  guard
    let xmlRootList = xml["exchangeRateMonthList"].all.first,
    let period = xmlRootList.element?.attribute(by: "Period")?.text,
    let month = parseRepresentingMonth(from: period)
  else {
    return nil
  }
  let rates = Dictionary(grouping: xmlRootList.children.compactMap {
    Rate(xmlIndexer: $0)
  }, by: {
    $0.currency.code
  })
  return MonthlyRate(month: month, rates: rates)
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
