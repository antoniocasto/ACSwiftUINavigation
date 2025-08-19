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
            targets: ["ACSwiftUINavigation", "ACNavigationRegistry"]
        ),
    ],
    targets: [
        .target(
            name: "ACSwiftUINavigation",
            path: "Sources/ACSwiftUINavigation"
        ),
        .target(
            name: "ACNavigationRegistry",
            dependencies: ["ACSwiftUINavigation"],
            path: "Sources/ACNavigationRegistry"
        ),
        .testTarget(
            name: "ACSwiftUINavigationTests",
            dependencies: ["ACSwiftUINavigation"]
        ),
    ]
)
