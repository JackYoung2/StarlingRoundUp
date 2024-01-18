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
        .library(name: "SavingsGoalListFeature", targets: ["SavingsGoalListFeature"]),
        .library(name: "SavingsGoalFeature", targets: ["SavingsGoalFeature"]),
        .library(name: "CreateSavingsGoalFeature", targets: ["CreateSavingsGoalFeature"])
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
                "SavingsGoalListFeature",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift")
            ]
        ),
        .target(name: "Transaction", dependencies: ["Views", "SharedModel", "RoundUpClient"]),
        .target(name: "SharedModel"),
        .target(name: "RoundUpClient", dependencies: ["Common"]),
        .target(
            name: "Common",
            resources: [.process("Resources")]
        ),
        .target(
            name: "SavingsGoalListFeature",
            dependencies: [
                "Views", 
                "SharedModel",
                "SavingsGoalFeature",
                "CreateSavingsGoalFeature",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift")
            ]
        ),
        .target(
            name: "SavingsGoalFeature",
            dependencies: [
                "Views",
                "SharedModel",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift")
            ]
        ),
        .target(
            name: "CreateSavingsGoalFeature",
            dependencies: [
                "Views",
                "SharedModel",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift")
            ]
        )
    ]
)
