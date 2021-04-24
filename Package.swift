// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fabricversions",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.2"),
        .package(url: "https://github.com/cx-org/CombineX", from: "0.3.1"),
    ],
    targets: [
        .target(
            name: "fabricversions",
            dependencies: [
              .product(name: "ArgumentParser", package: "swift-argument-parser"),
              .product(name: "CombineX", package: "CombineX"),
            ]),
    ]
)
