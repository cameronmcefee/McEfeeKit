// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "McEfeeKit",
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
