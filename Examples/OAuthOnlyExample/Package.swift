// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "OAuthOnlyExample",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        // Vapor framework
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // Fluent ORM
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        // Fluent PostgreSQL driver
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.8.0"),
        // VaporAuth - use local package during development
        .package(path: "../../")
    ],
    targets: [
        .executableTarget(
            name: "Run",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                // VaporAuthCore + VaporAuthOAuth
                .product(name: "VaporAuthCore", package: "VaporAuth"),
                .product(name: "VaporAuthOAuth", package: "VaporAuth"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny")
] }
