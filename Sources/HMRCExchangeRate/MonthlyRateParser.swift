import Foundation
import SWXMLHash

func parseMonthlyRateXml(_ xmlContent: String) -> [Rate] {
  let xml = SWXMLHash.parse(xmlContent)
  guard let xmlRootList = xml["exchangeRateMonthList"].all.first else {
    return []
  }
  return xmlRootList.children.compactMap { Rate(xmlIndexer: $0) }
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
