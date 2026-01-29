import Vapor
import VaporAuthCore

/// Flexible middleware to check for specific roles
/// Requires token authentication to be performed first
///
/// Usage:
/// ```swift
/// let moderatorRoutes = app.grouped(SimpleTokenAuthenticator())
///     .grouped(RoleAuthMiddleware(requiredRole: "moderator"))
/// moderatorRoutes.post("content", "approve", use: approveContent)
///
/// // Or check multiple roles
/// let staffRoutes = app.grouped(SimpleTokenAuthenticator())
///     .grouped(RoleAuthMiddleware(allowedRoles: ["admin", "moderator"]))
/// ```
public struct RoleAuthMiddleware: AsyncMiddleware {
    private let allowedRoles: Set<String>

    /// Initialize with a single required role
    public init(requiredRole: String) {
        self.allowedRoles = [requiredRole]
    }

    /// Initialize with multiple allowed roles
    public init(allowedRoles: [String]) {
        self.allowedRoles = Set(allowedRoles)
    }

    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        // Get authenticated user
        guard let user = request.auth.get(DefaultUser.self) else {
            throw Abort(.unauthorized, reason: "Authentication required")
        }

        // Check if user has any of the allowed roles
        guard allowedRoles.contains(user.role) else {
            throw Abort(.forbidden, reason: "Required role: \(allowedRoles.joined(separator: " or "))")
        }

        return try await next.respond(to: request)
    }
}
