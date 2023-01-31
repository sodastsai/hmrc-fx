// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "hmrc-fx",
  platforms: [
    .macOS(.v12),
  ],
  products: [
    .library(name: "HMRCExchangeRate", targets: ["HMRCExchangeRate"]),
    .executable(name: "rate-query", targets: ["RateQuery"]),
  ],
  dependencies: [
    .package(url: "https://github.com/MaxDesiatov/XMLCoder", .upToNextMinor(from: "0.15.0")),
    .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "1.2.0")),
    .package(url: "https://github.com/sindresorhus/Regex", from: "1.0.0"),
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.4"),
  ],
  targets: [
    .target(name: "HMRCExchangeRate",
            dependencies: [
              .product(name: "XMLCoder", package: "XMLCoder"),
              .product(name: "Regex", package: "Regex"),
            ]),
    .testTarget(name: "HMRCExchangeRateTests",
                dependencies: [
                  .target(name: "HMRCExchangeRate"),
                ],
                resources: [
                  .process("Resources"),
                ]),
    .executableTarget(name: "RateQuery", dependencies: [
      .target(name: "HMRCExchangeRate"),
      .product(name: "ArgumentParser", package: "swift-argument-parser"),
    ]),
  ]
)
