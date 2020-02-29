// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "ImageAttributesPublishPlugin",
    products: [
        .library(
            name: "ImageAttributesPublishPlugin",
            targets: ["ImageAttributesPublishPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.1.0"),
    ],
    targets: [
        .target(    
            name: "ImageAttributesPublishPlugin",
            dependencies: ["Publish"]),
        .testTarget(
            name: "ImageAttributesPublishPluginTests",
            dependencies: ["ImageAttributesPublishPlugin"]),
    ]
)
