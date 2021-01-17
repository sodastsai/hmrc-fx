# HMRC FX Rate

This package provide currency conversion via [UK HMRC rate](http://www.hmrc.gov.uk/softwaredevelopers/2021-exrates.html)

![Swift](https://github.com/sodastsai/hmrc-fx/workflows/Swift/badge.svg)

## Example

```swift
import HMRCExchangeRate

if let rate = RateSource.directHMRC.rate(of: "TWD", at: Date())?.first {
  print("\(rate)")
}
```
