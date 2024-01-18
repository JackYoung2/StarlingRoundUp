// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RoundUpPackage",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "Views", targets: ["Views"]),
        .library(name: "RoundUpListFeature", targets: ["RoundUpListFeature"]),
        .library(name: "Transaction", targets: ["Transaction"]),
        .library(name: "Common", targets: ["Common"]),
        .library(name: "SharedModel", targets: ["SharedModel"]),
        .library(name: "RoundUpClient", targets: ["RoundUpClient"]),
        .library(name: "SavingsGoalFeature", targets: ["SavingsGoalFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0"))
    ],
    targets: [
        .target(name: "Views", dependencies: ["Common"]),
        .target(name: "AppFeature", dependencies: ["Views", "SharedModel", "RoundUpListFeature"]),
        .target(
            name: "RoundUpListFeature",
            dependencies: [
                "Views", 
                "SharedModel",
                "Transaction",
                "RoundUpClient",
                "SavingsGoalFeature",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift")
            ]
        ),
        .target(name: "Transaction", dependencies: ["Views", "SharedModel"]),
        .target(name: "SharedModel"),
        .target(name: "RoundUpClient"),
        .target(
            name: "Common",
            resources: [.process("Resources")]
        ),
        .target(name: "SavingsGoalFeature", dependencies: ["Views", "SharedModel"])
        
    ]
)
