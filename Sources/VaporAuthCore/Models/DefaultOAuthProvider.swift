import Fluent
import Vapor

/// Default implementation of OAuth Provider model
/// Stores OAuth provider information for users
public final class DefaultOAuthProvider: Model, @unchecked Sendable {
    public static let schema = "oauth_providers"

    @ID(key: .id)
    public var id: UUID?

    @Parent(key: "user_id")
    public var user: DefaultUser

    @Field(key: "provider_name")
    public var providerName: String

    @Field(key: "provider_user_id")
    public var providerUserID: String

    @Field(key: "provider_email")
    public var providerEmail: String

    @OptionalField(key: "access_token")
    public var accessToken: String?

    @OptionalField(key: "refresh_token")
    public var refreshToken: String?

    @OptionalField(key: "expires_at")
    public var expiresAt: Date?

    @Timestamp(key: "created_at", on: .create)
    public var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    public var updatedAt: Date?

    public init() { }

    public init(
        id: UUID? = nil,
        userID: DefaultUser.IDValue,
        providerName: String,
        providerUserID: String,
        providerEmail: String,
        accessToken: String? = nil,
        refreshToken: String? = nil,
        expiresAt: Date? = nil
    ) {
        self.id = id
        self.$user.id = userID
        self.providerName = providerName
        self.providerUserID = providerUserID
        self.providerEmail = providerEmail
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
    }
}

// MARK: - Protocol Conformance

extension DefaultOAuthProvider: OAuthProviderProtocol {
    public typealias User = DefaultUser
}

// Note: To use OAuth with your User model, add this to your User:
//
// @Children(for: \.$user)
// var oauthProviders: [DefaultOAuthProvider]
//
// extension User: OAuthAuthenticatable {
//     typealias OAuthProviderType = DefaultOAuthProvider
// }
