// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CronParser",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "CronParser", targets: ["CronParser"]),
    ],
    targets: [
        .target(name: "CronParser", path: "Sources"),
        .testTarget(name: "CronParserTests", dependencies: ["CronParser"], path: "Tests"),
    ]
)
