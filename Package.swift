// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SDSCore",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
        .macCatalyst(.v18)
    ],
    products: [
        .library(
            name: "SDSCore",
            targets: ["SDSCore"]),
    ],
    targets: [
        .target(
            name: "SDSCore"
        )
    ]
)

