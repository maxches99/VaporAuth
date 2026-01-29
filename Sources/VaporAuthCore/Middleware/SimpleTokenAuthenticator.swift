import Fluent
import Vapor

/// Simple token authenticator for DefaultUser and DefaultUserToken
/// For custom user types, copy and adapt this authenticator
///
/// Usage:
/// ```swift
/// let protected = routes.grouped(SimpleTokenAuthenticator())
/// protected.get("me", use: getCurrentUser)
/// ```
public struct SimpleTokenAuthenticator: AsyncBearerAuthenticator {
    public init() {}

    public func authenticate(
        bearer: BearerAuthorization,
        for request: Request
    ) async throws {
        // Query for token with user loaded
        guard let token = try await DefaultUserToken.query(on: request.db)
            .filter(\.$value == bearer.token)
            .with(\.$user)
            .first()
        else {
            return
        }

        // Check if token is still valid
        guard token.isValid else {
            // Delete expired token
            try await token.delete(on: request.db)
            return
        }

        // Login user
        request.auth.login(token.user)
    }
}

/// Convenience typealias
public typealias DefaultTokenAuthenticator = SimpleTokenAuthenticator
