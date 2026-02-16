// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Pical",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "PicalApp",
            targets: ["PicalApp"]
        )
    ],
    targets: [
        .executableTarget(
            name: "PicalApp",
            path: "Sources/PicalApp",
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "PicalAppTests",
            dependencies: ["PicalApp"],
            path: "Tests/PicalAppTests"
        )
    ]
)
