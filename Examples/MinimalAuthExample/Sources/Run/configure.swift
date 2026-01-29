import Vapor
import Fluent
import FluentPostgresDriver
import VaporAuthCore

/// Configure the application
public func configure(_ app: Application) async throws {
    // MARK: - Server Configuration

    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080

    // MARK: - Middleware Configuration

    // Serve files from /Public directory
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // MARK: - Database Configuration

    let databaseHost = Environment.get("DATABASE_HOST") ?? "localhost"
    let databasePort = Environment.get("DATABASE_PORT").flatMap(Int.init) ?? 5432
    let databaseUsername = Environment.get("DATABASE_USERNAME") ?? "vapor_username"
    let databasePassword = Environment.get("DATABASE_PASSWORD") ?? "vapor_password"
    let databaseName = Environment.get("DATABASE_NAME") ?? "vapor_database"

    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: databaseHost,
                port: databasePort,
                username: databaseUsername,
                password: databasePassword,
                database: databaseName,
                tls: .prefer(try .init(configuration: .clientDefault))
            )
        ),
        as: .psql
    )

    // MARK: - Migrations

    // Only core authentication migrations - minimal setup
    app.migrations.add(CreateUserMigration<DefaultUser>())
    app.migrations.add(CreateTokenMigration<DefaultUserToken>())

    // MARK: - Routes

    try routes(app)

    app.logger.info("MinimalAuthExample configured successfully!")
    app.logger.info("Server running on http://\(app.http.server.configuration.hostname):\(app.http.server.configuration.port)")
}
