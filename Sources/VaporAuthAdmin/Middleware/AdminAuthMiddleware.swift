import Vapor
import VaporAuthCore

/// Middleware to ensure the authenticated user has admin role
/// Requires token authentication to be performed first
///
/// Usage:
/// ```swift
/// let adminRoutes = app.grouped(SimpleTokenAuthenticator())
///     .grouped(AdminAuthMiddleware())
/// adminRoutes.get("admin", "users", use: listUsers)
/// ```
public struct AdminAuthMiddleware: AsyncMiddleware {
    public init() {}

    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        // Get authenticated user
        guard let user = request.auth.get(DefaultUser.self) else {
            throw Abort(.unauthorized, reason: "Authentication required")
        }

        // Check if user is admin
        guard user.isAdmin else {
            throw Abort(.forbidden, reason: "Admin access required")
        }

        return try await next.respond(to: request)
    }
}
