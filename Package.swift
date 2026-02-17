// swift-tools-version: 6.0
import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Pical",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .iOSApplication(
            name: "Pical",
            targets: ["PicalApp"],
            bundleIdentifier: "com.magpiesoft.pical",
            teamIdentifier: "YOUR_TEAM_IDENTIFIER",
            displayVersion: "0.1.0",
            bundleVersion: "1",
            appIcon: .none,
            accentColor: .none,
            supportedDeviceFamilies: [.phone],
            supportedInterfaceOrientations: [
                .portrait,
                .portraitUpsideDown(.when(deviceFamilies: [.phone]))
            ]
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
