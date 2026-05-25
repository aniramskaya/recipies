// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "RecipeEdit",
    platforms: [.iOS(.v17), .macOS(.v15)],
    products: [
        .library(
            name: "RecipeEdit",
            targets: ["RecipeEdit"]
        ),
    ],
    dependencies: [
        .package(path: "../../Shared/RecipeUIKit"),
        .package(path: "../../Shared/Scenarios"),
        .package(path: "../../Shared/TestHelpers"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.0.0"),
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.10.0"),
    ],
    targets: [
        .target(
            name: "RecipeEdit",
            dependencies: [
                .product(name: "RecipeUIKit", package: "RecipeUIKit"),
                .product(name: "Scenarios", package: "Scenarios"),
            ]
        ),
        .testTarget(
            name: "RecipeEditTests",
            dependencies: [
                "RecipeEdit",
                .product(name: "TestHelpers", package: "TestHelpers"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "ViewInspector", package: "ViewInspector"),
            ]
        ),
    ]
)
