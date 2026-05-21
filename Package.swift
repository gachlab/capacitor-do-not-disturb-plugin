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
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", .upToNextMajor(from: "8.0.0"))
    ],
    targets: [
        .target(
            name: "DoNotDisturbPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Plugin"),
        .testTarget(
            name: "DoNotDisturbPluginTests",
            dependencies: ["DoNotDisturbPlugin"],
            path: "ios/PluginTests")
    ]
)
