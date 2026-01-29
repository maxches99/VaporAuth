import Vapor
import VaporAuthCore
import VaporAuthOAuth
import VaporAuthAdmin
import VaporAuthFields

/// Register application routes
public func routes(_ app: Application) throws {
    // MARK: - Health Check

    app.get("health") { req async -> String in
        return "OK"
    }

    // MARK: - Core Authentication Routes

    try app.register(collection: SimpleAuthController())

    // MARK: - OAuth Routes

    try app.register(collection: SimpleOAuthController())

    // MARK: - Public Registration Fields Routes

    try app.register(collection: PublicFieldsController())

    // MARK: - Admin Routes (Protected)

    let adminRoutes = app.grouped(SimpleTokenAuthenticator())
        .grouped(AdminAuthMiddleware())

    try adminRoutes.register(collection: AdminFieldsController())

    // MARK: - Static Files (Optional - for frontend)

    // Serve files from Public directory
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.logger.info("Routes registered successfully!")
}
