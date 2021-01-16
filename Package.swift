// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "HMRCExchangeRate",
  platforms: [
    .macOS(.v11),
  ],
  products: [
    .library(name: "HMRCExchangeRate", targets: ["HMRCExchangeRate"]),
  ],
  targets: [
    .target(name: "HMRCExchangeRate"),
    .testTarget(name: "HMRCExchangeRateTests",
                dependencies: [
                  "HMRCExchangeRate",
                ]),
  ]
)
