// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "hmrc-fx",
  platforms: [
    .macOS(.v11),
  ],
  products: [
    .library(name: "HMRCExchangeRate", targets: ["HMRCExchangeRate"]),
  ],
  dependencies: [
    .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", .upToNextMinor(from: "0.12.0")),
  ],
  targets: [
    .target(name: "HMRCExchangeRate",
            dependencies: [
              .product(name: "XMLCoder", package: "XMLCoder"),
            ]),
    .testTarget(name: "HMRCExchangeRateTests",
                dependencies: [
                  .target(name: "HMRCExchangeRate"),
                ],
                resources: [
                  .process("Resources"),
                ]),
  ]
)
