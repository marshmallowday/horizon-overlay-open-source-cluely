// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HorizonOverlay",
    products: [
        .executable(name: "QuickCaptureApp", targets: ["QuickCaptureApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/compnerd/swift-win32.git", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "QuickCaptureApp",
            dependencies: [
                .product(name: "SwiftWin32", package: "swift-win32")
            ],
            path: "Constella Horizon/Windows"
        )
    ]
)
