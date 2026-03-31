// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RayTracer",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "RayTracer",
            path: "Sources/RayTracer"
        )
    ]
)
