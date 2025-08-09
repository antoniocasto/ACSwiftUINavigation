// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ACSwiftUINavigation",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ACSwiftUINavigation",
            targets: ["ACSwiftUINavigation"]
        ),
    ],
    targets: [
        .target(
            name: "ACSwiftUINavigation"
        ),
        .testTarget(
            name: "ACSwiftUINavigationTests",
            dependencies: ["ACSwiftUINavigation"]
        ),
    ]
)
