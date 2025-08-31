// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NavigationDrawer",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "NavigationDrawer",
            targets: ["NavigationDrawer"]
        ),
    ],
    targets: [
        .target(
            name: "NavigationDrawer"
        ),
    ]
)
