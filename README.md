# HMRC FX Rate

This package provide currency conversion via [UK HMRC rate](http://www.hmrc.gov.uk/softwaredevelopers/2021-exrates.html)

![Swift](https://github.com/sodastsai/hmrc-fx/workflows/Swift/badge.svg)

## Example

Please reference [HMRC's XML](http://www.hmrc.gov.uk/softwaredevelopers/2021-exrates.html) for possible values of the "CurrencyCode".

```swift
import Foundation
import HMRCExchangeRate

// Get exchange rate by `Date`
if let rate = RateSource.directHMRC.rate(of: "TWD", at: Date())?.first {
    print("Current rate - \(rate)")
}

// Get exchange rate of a certain month
if let rate = RateSource.directHMRC.rate(of: "TWD", in: Month(.sep, in: 2020))?.first {
    print("Rate of Sept 2020 - \(rate)")
}
```


## Setup as a dependency

This is a Swift Package, and hence you could use it in a way like this
```swift
// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "fx-example",
    platforms: [
        .macOS(.v11),
    ],
    dependencies: [
        .package(url: "https://github.com/sodastsai/hmrc-fx.git", from: "0.2.0"),
    ],
    targets: [
        .target(
            name: "fx-example",
            dependencies: [
                .product(name: "HMRCExchangeRate", package: "hmrc-fx"),
            ]
        ),
    ]
)
```
