// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MultiCurrency-for-macOS",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "MultiCurrencyCore", targets: ["MultiCurrencyCore"]),
        .executable(name: "MultiCurrencyApp", targets: ["MultiCurrencyApp"])
    ],
    targets: [
        .target(name: "MultiCurrencyCore"),
        .executableTarget(
            name: "MultiCurrencyApp",
            dependencies: ["MultiCurrencyCore"]
        ),
        .testTarget(
            name: "MultiCurrencyCoreTests",
            dependencies: ["MultiCurrencyCore"]
        )
    ]
)
