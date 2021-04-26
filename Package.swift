// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fabricversions",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.2"),
        .package(url: "https://github.com/yahoojapan/SwiftyXMLParser", from: "5.3.0"),
    ],
    targets: [
        .target(
            name: "fabricversions",
            dependencies: [
              .product(name: "ArgumentParser", package: "swift-argument-parser"),
              .product(name: "SwiftyXMLParser", package: "SwiftyXMLParser"),
            ]),
    ]
)
