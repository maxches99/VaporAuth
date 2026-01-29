// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "VaporAuth",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Individual module products
        .library(name: "VaporAuthCore", targets: ["VaporAuthCore"]),
        .library(name: "VaporAuthOAuth", targets: ["VaporAuthOAuth"]),
        .library(name: "VaporAuthAdmin", targets: ["VaporAuthAdmin"]),
        .library(name: "VaporAuthFields", targets: ["VaporAuthFields"]),

        // Convenience product with all modules
        .library(name: "VaporAuth", targets: [
            "VaporAuthCore",
            "VaporAuthOAuth",
            "VaporAuthAdmin",
            "VaporAuthFields"
        ]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🗄 An ORM for SQL and NoSQL databases
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        // 🐘 Fluent driver for Postgres
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.8.0"),
        // 🍃 An expressive, performant, and extensible templating language
        .package(url: "https://github.com/vapor/leaf.git", from: "4.3.0"),
        // 🔐 OAuth provider integrations
        .package(url: "https://github.com/vapor-community/Imperial.git", from: "1.0.0"),
    ],
    targets: [
        // MARK: - Core Module
        .target(
            name: "VaporAuthCore",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
            ],
            swiftSettings: swiftSettings
        ),

        // MARK: - OAuth Module
        .target(
            name: "VaporAuthOAuth",
            dependencies: [
                .target(name: "VaporAuthCore"),
                .product(name: "ImperialCore", package: "Imperial"),
                .product(name: "ImperialGoogle", package: "Imperial"),
            ],
            swiftSettings: swiftSettings
        ),

        // MARK: - Admin Module
        .target(
            name: "VaporAuthAdmin",
            dependencies: [
                .target(name: "VaporAuthCore"),
            ],
            swiftSettings: swiftSettings
        ),

        // MARK: - Fields Module
        .target(
            name: "VaporAuthFields",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                // Optional integration with Core for admin authentication
                .target(name: "VaporAuthCore"),
            ],
            swiftSettings: swiftSettings
        ),

        // MARK: - Tests
        .testTarget(
            name: "VaporAuthCoreTests",
            dependencies: [
                .target(name: "VaporAuthCore"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "VaporAuthOAuthTests",
            dependencies: [
                .target(name: "VaporAuthOAuth"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "VaporAuthAdminTests",
            dependencies: [
                .target(name: "VaporAuthAdmin"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "VaporAuthFieldsTests",
            dependencies: [
                .target(name: "VaporAuthFields"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)

var swiftSettings: [SwiftSetting] {
    [
        .enableUpcomingFeature("ExistentialAny"),
    ]
}
