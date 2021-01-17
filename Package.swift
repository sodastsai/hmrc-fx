// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "HMRCExchangeRate",
  platforms: [
    .macOS(.v11),
  ],
  products: [
    .library(name: "HMRCExchangeRate", targets: ["HMRCExchangeRate"]),
    .library(name: "HMRCExchangeRate2020Resources", targets: ["HMRCExchangeRate2020Resources"]),
  ],
  dependencies: [
    .package(url: "https://github.com/drmohundro/SWXMLHash.git", .upToNextMajor(from: "5.0.0")),
  ],
  targets: [
    .target(name: "HMRCExchangeRate",
            dependencies: [
              "SWXMLHash",
            ]),
    .testTarget(name: "HMRCExchangeRateTests",
                dependencies: [
                  "HMRCExchangeRate",
                ],
                resources: [
                  .process("Resources"),
                ]),
    .target(name: "HMRCExchangeRate2020Resources",
            dependencies: [
              "HMRCExchangeRate",
            ],
            resources: [
              .process("Resources"),
            ]),
  ]
)
