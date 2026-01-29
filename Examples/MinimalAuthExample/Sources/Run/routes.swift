import Vapor
import VaporAuthCore

/// Register application routes
public func routes(_ app: Application) throws {
    // MARK: - Health Check

    app.get("health") { req async -> String in
        return "OK"
    }

    // MARK: - Core Authentication Routes

    // Register the authentication controller
    // Provides: POST /auth/register, POST /auth/login, GET /auth/me, POST /auth/logout
    try app.register(collection: SimpleAuthController())

    app.logger.info("Routes registered successfully!")
}
