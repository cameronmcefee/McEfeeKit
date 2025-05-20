// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "McEfeeKit",
  platforms: [
    .macOS(.v14), .iOS(.v17),
  ],
  products: [
    .library(
      name: "McEfeeKit",
      targets: ["McEfeeKit"]
    ),
  ],
  targets: [
    .target(
      name: "McEfeeKit"),
    .testTarget(
      name: "McEfeeKitTests",
      dependencies: ["McEfeeKit"]
    ),
  ]
)
