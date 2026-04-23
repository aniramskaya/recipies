// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "EditRecipe",
    platforms: [.iOS(.v16), .macOS(.v15)],
    products: [
        .library(
            name: "EditRecipe",
            targets: ["EditRecipe"]
        ),
    ],
    dependencies: [
        .package(path: "../../Shared/RecipeUIKit"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.0.0"),
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.10.0"),
    ],
    targets: [
        .target(
            name: "EditRecipe",
            dependencies: [
                .product(name: "RecipeUIKit", package: "RecipeUIKit"),
            ]
        ),
        .testTarget(
            name: "EditRecipeTests",
            dependencies: [
                "EditRecipe",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "ViewInspector", package: "ViewInspector"),
            ]
        ),
    ]
)
