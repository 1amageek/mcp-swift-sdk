// swift-tools-version:6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// Base dependencies needed on all platforms
var dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/apple/swift-system.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.5.0"),
    .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "1.0.0"),
    .package(url: "https://github.com/mattt/eventsource.git", from: "1.1.0"),
    .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
]

// Target dependencies needed on all platforms
var targetDependencies: [Target.Dependency] = [
    .product(name: "SystemPackage", package: "swift-system"),
    .product(name: "Logging", package: "swift-log"),
    .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
    .product(
        name: "EventSource", package: "eventsource",
        condition: .when(platforms: [.macOS, .iOS, .tvOS, .visionOS, .watchOS, .macCatalyst])),
    .product(name: "NIOCore", package: "swift-nio"),
    .product(name: "NIOPosix", package: "swift-nio"),
    .product(name: "NIOHTTP1", package: "swift-nio"),
]

let package = Package(
    name: "mcp-swift-sdk",
    platforms: [
        .macOS(.v15),
        .macCatalyst(.v18),
        .iOS(.v18),
        .watchOS(.v11),
        .tvOS(.v18),
        .visionOS(.v2),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MCP",
            targets: ["MCP"]),
        .executable(
            name: "mcp-everything-server",
            targets: ["MCPConformanceServer"]),
        .executable(
            name: "mcp-everything-client",
            targets: ["MCPConformanceClient"])
    ],
    dependencies: dependencies,
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MCP",
            dependencies: targetDependencies,
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "MCPTests",
            dependencies: ["MCP"] + targetDependencies),
        .executableTarget(
            name: "MCPConformanceServer",
            dependencies: ["MCP"] + targetDependencies,
            path: "Sources/MCPConformance/Server"),
        .executableTarget(
            name: "MCPConformanceClient",
            dependencies: ["MCP"] + targetDependencies,
            path: "Sources/MCPConformance/Client")
    ]
)
