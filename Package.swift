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
    .executable(name: "rate-listing", targets: ["RateListing"]),
  ],
  dependencies: [
    .package(url: "https://github.com/MaxDesiatov/XMLCoder", .upToNextMinor(from: "0.15.0")),
    .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "1.2.0")),
    .package(url: "https://github.com/sindresorhus/Regex", from: "1.0.0"),
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.4"),
    .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-async-algorithms", from: "0.0.4"),
    .package(url: "https://github.com/dehesa/CodableCSV.git", from: "0.6.7"),
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
    .executableTarget(name: "RateListing", dependencies: [
      .target(name: "HMRCExchangeRate"),
      .product(name: "ArgumentParser", package: "swift-argument-parser"),
      .product(name: "Algorithms", package: "swift-algorithms"),
      .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
      .product(name: "CodableCSV", package: "CodableCSV"),
    ]),
  ]
)
