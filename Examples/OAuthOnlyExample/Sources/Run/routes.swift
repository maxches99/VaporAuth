import Vapor
import VaporAuthCore
import VaporAuthOAuth

/// Register application routes
public func routes(_ app: Application) throws {
    // MARK: - Health Check

    app.get("health") { req async -> String in
        return "OK"
    }

    // MARK: - Core Authentication Routes

    // Traditional email/password authentication
    try app.register(collection: SimpleAuthController())

    // MARK: - OAuth Routes

    // Google OAuth authentication
    // Provides: GET /auth/google, GET /auth/google/callback, GET /auth/providers
    try app.register(collection: SimpleOAuthController())

    app.logger.info("Routes registered successfully!")
}
