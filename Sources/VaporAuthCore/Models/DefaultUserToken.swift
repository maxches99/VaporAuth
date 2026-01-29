import Fluent
import Vapor

/// Default implementation of a User Token model
/// Tokens expire after 30 days by default
public final class DefaultUserToken: Model, @unchecked Sendable {
    public static let schema = "user_tokens"

    @ID(key: .id)
    public var id: UUID?

    @Field(key: "value")
    public var value: String

    @Parent(key: "user_id")
    public var user: DefaultUser

    @Timestamp(key: "created_at", on: .create)
    public var createdAt: Date?

    @Field(key: "expires_at")
    public var expiresAt: Date

    public init() { }

    public init(
        id: UUID? = nil,
        value: String,
        userID: DefaultUser.IDValue
    ) {
        self.id = id
        self.value = value
        self.$user.id = userID
        // Default expiration: 30 days from creation
        self.expiresAt = Date().addingTimeInterval(60 * 60 * 24 * 30)
    }
}

// MARK: - Protocol Conformances

extension DefaultUserToken: TokenAuthenticatable {
    public typealias User = DefaultUser
    // Uses default isValid implementation from protocol
}

extension DefaultUserToken: ModelTokenAuthenticatable {
    public static let valueKey: KeyPath<DefaultUserToken, FieldProperty<DefaultUserToken, String>> = \.$value
    public static let userKey: KeyPath<DefaultUserToken, ParentProperty<DefaultUserToken, DefaultUser>> = \.$user
}
