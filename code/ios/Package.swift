// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "360Stitch",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .executable(name: "360StitchApp", targets: ["360Stitch"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/opencv/opencv-ios",
            .upToNextMajor(from: "4.9.0")
        ),
    ],
    targets: [
        .executableTarget(
            name: "360Stitch",
            dependencies: ["OpenCV"],
            path: "360Stitch",
            resources: []
        ),
    ]
)
