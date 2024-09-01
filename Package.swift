// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KaraokeSDK",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "KaraokeSDK",
            targets: ["KaraokeSDK"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1")),
        .package(url: "https://github.com/tid-kijyun/Kanna.git", .upToNextMajor(from: "5.3.0")),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", .upToNextMajor(from: "4.2.2")),
        .package(url: "https://github.com/realm/SwiftLint.git", .upToNextMajor(from: "0.56.2")),
    ],
    targets: [
        .target(
            name: "KaraokeSDK",
            dependencies: ["Alamofire", "Kanna", "KeychainAccess"],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .testTarget(
            name: "KaraokeSDKTests",
            dependencies: ["KaraokeSDK"]
        ),
    ]
)
