import Fluent
import Vapor

// MARK: - OAuth Authentication Protocols

/// Protocol for users supporting OAuth authentication
/// Users conforming to this can link OAuth providers to their account
public protocol OAuthAuthenticatable: AuthenticatableUser {
    associatedtype OAuthProviderType: OAuthProviderProtocol where OAuthProviderType.User == Self

    var oauthProviders: [OAuthProviderType] { get set }
}

/// Protocol for OAuth provider records
/// Stores OAuth provider information and tokens for a user
public protocol OAuthProviderProtocol: Model {
    associatedtype User: OAuthAuthenticatable where User.OAuthProviderType == Self

    var id: UUID? { get set }
    var providerName: String { get set }
    var providerUserID: String { get set }
    var providerEmail: String { get set }
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    var expiresAt: Date? { get set }
    var createdAt: Date? { get set }
}

/// Protocol for OAuth service operations
/// Services conforming to this handle OAuth provider integration logic
public protocol OAuthServiceProtocol {
    associatedtype User: OAuthAuthenticatable

    /// Find existing user by OAuth provider or create new one
    func findOrCreateUser(
        providerName: String,
        providerUserID: String,
        email: String,
        name: String?,
        accessToken: String?,
        refreshToken: String?,
        expiresAt: Date?,
        on db: Database
    ) async throws -> User

    /// Link OAuth provider to existing user
    func linkProvider(
        user: User,
        providerName: String,
        providerUserID: String,
        email: String,
        accessToken: String?,
        refreshToken: String?,
        expiresAt: Date?,
        on db: Database
    ) async throws -> User.OAuthProviderType
}
