// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RoundUpPackage",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "Views", targets: ["Views"]),
        .library(name: "TransactionFeedFeature", targets: ["TransactionFeedFeature"]),
        .library(name: "Common", targets: ["Common"]),
        .library(name: "SharedModel", targets: ["SharedModel"]),
        .library(name: "RoundUpClient", targets: ["RoundUpClient"]),
        .library(name: "SavingsGoalListFeature", targets: ["SavingsGoalListFeature"]),
        .library(name: "SavingsGoalFeature", targets: ["SavingsGoalFeature"]),
        .library(name: "CreateSavingsGoalFeature", targets: ["CreateSavingsGoalFeature"]),
        .library(name: "AccountsFeature", targets: ["AccountsFeature"]),
        .library(name: "LoginFeature", targets: ["LoginFeature"]),
        .library(name: "SessionManager", targets: ["SessionManager"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", from: "5.0.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2")
    ],
    targets: [
        .target(name: "Views", dependencies: ["Common"]),
        .target(name: "AppFeature", dependencies: ["Views", "SharedModel", "TransactionFeedFeature"]),
        .target(
            name: "TransactionFeedFeature",
            dependencies: [
                "Views", 
                "SharedModel",
                "RoundUpClient",
                "SavingsGoalListFeature",
                "AccountsFeature",
                "KeychainClient",
                "LoginFeature",
                "SessionManager",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxDataSources", package: "RxDataSources")
            ]
        ),
        .target(name: "SharedModel"),
        .target(name: "RoundUpClient", dependencies: ["Common"]),
        .target(
            name: "Common",
            dependencies: ["SharedModel"],
            resources: [.process("Resources")]
        ),
        .target(
            name: "SavingsGoalListFeature",
            dependencies: [
                "Views", 
                "SharedModel",
                "SavingsGoalFeature",
                "CreateSavingsGoalFeature",
                "SessionManager",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxDataSources", package: "RxDataSources")
            ]
        ),
        .target(
            name: "SavingsGoalFeature",
            dependencies: [
                "Views",
                "SharedModel",
                "SessionManager",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift")
            ]
        ),
        .target(
            name: "CreateSavingsGoalFeature",
            dependencies: [
                "Views",
                "SharedModel",
                "APIClient",
                "SessionManager",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift")
            ]
        ),
        .target(
            name: "APIClient",
            dependencies: [
                "Common",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift")
            ]
        ),
        .target(
            name: "AccountsFeature",
            dependencies: ["APIClient", "SharedModel"]
        ),
        .target(
            name: "KeychainClient",
            dependencies: [.product(name: "KeychainAccess", package: "KeychainAccess")]
        ),
        .target(
            name: "SessionManager",
            dependencies: ["KeychainClient"]
        ),
        .target(
            name: "LoginFeature",
            dependencies: [
                "APIClient",
                "Common",
                "KeychainClient",
                "SessionManager",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift")
            ]
        ),
        .testTarget(
            name: "RoundUpPackageTests",
            dependencies: [
                "AppFeature",
                .product(name: "RxTest", package: "RxSwift")
            ])
    ]
      
)
