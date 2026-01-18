// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "GachlabCapacitorDndPlugin",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "GachlabCapacitorDndPlugin",
            targets: ["DoNotDisturbPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "DoNotDisturbPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Plugin",
            sources: ["DoNotDisturb.swift", "DoNotDisturbPlugin.swift"],
            publicHeadersPath: "Public")
    ]
)
