import Fluent
import Vapor

/// Default implementation of a User model with all authentication features
/// This model can be used as-is or as a reference for creating custom user models
public final class DefaultUser: Model, @unchecked Sendable {
    public static let schema = "users"

    @ID(key: .id)
    public var id: UUID?

    @Field(key: "email")
    public var email: String

    @OptionalField(key: "password_hash")
    public var passwordHash: String?

    @Field(key: "name")
    public var name: String

    @Field(key: "role")
    public var role: String

    @Timestamp(key: "created_at", on: .create)
    public var createdAt: Date?

    @Children(for: \.$user)
    public var tokens: [DefaultUserToken]

    @Children(for: \.$user)
    public var oauthProviders: [DefaultOAuthProvider]

    @Children(for: \.$user)
    public var customFields: [UserCustomField]

    public init() { }

    public init(
        id: UUID? = nil,
        email: String,
        passwordHash: String?,
        name: String,
        role: String = "user"
    ) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
        self.name = name
        self.role = role
    }
}

// MARK: - Protocol Conformances

extension DefaultUser: AuthenticatableUser {
    public var hasPassword: Bool {
        passwordHash != nil
    }
}

extension DefaultUser: PasswordAuthenticatable {
    // Uses default implementation from protocol
}

extension DefaultUser: TokenGenerating {
    public typealias Token = DefaultUserToken

    public func generateToken() throws -> DefaultUserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}

extension DefaultUser: RoleAuthenticatable {
    // Uses default implementation from protocol
}

extension DefaultUser: OAuthAuthenticatable {
    public typealias OAuthProviderType = DefaultOAuthProvider
}

extension DefaultUser: CustomFieldsUser {
    public typealias CustomField = UserCustomField
}

extension DefaultUser: Authenticatable { }
