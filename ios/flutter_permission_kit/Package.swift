// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "FlutterPermissionKit", // Package name for Flutter Permission Kit plugin
    platforms: [
        .iOS(.v15) // Specify the minimum supported iOS version (iOS 15.0+)
    ],
    products: [
        // Defines the library product that can be used by other packages or apps
        .library(
            name: "FlutterPermissionKit",
            targets: ["FlutterPermissionKit"]) // The target the library product depends on
    ],
    dependencies: [

    ],
    targets: [
        // Defines the main target containing the plugin's Swift code
        .target(
            name: "FlutterPermissionKit",
            dependencies: [

            ],
            path: ".",
            sources: ["Classes"] 
        )
    ]
)