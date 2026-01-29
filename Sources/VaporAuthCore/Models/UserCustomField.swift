import Fluent
import Vapor

/// Model for storing user's custom field values
/// Links users to their custom registration field data
public final class UserCustomField: Model, @unchecked Sendable {
    public static let schema = "user_custom_fields"

    @ID(key: .id)
    public var id: UUID?

    /// Reference to the user
    @Parent(key: "user_id")
    public var user: DefaultUser

    /// Name of the field (matches RegistrationField.fieldName)
    @Field(key: "field_name")
    public var fieldName: String

    /// Value of the field (stored as string, cast based on field type)
    @Field(key: "field_value")
    public var fieldValue: String

    @Timestamp(key: "created_at", on: .create)
    public var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    public var updatedAt: Date?

    public init() { }

    public init(
        id: UUID? = nil,
        userID: DefaultUser.IDValue,
        fieldName: String,
        fieldValue: String
    ) {
        self.id = id
        self.$user.id = userID
        self.fieldName = fieldName
        self.fieldValue = fieldValue
    }
}

// MARK: - Protocol Conformance

extension UserCustomField: CustomFieldProtocol {
    public typealias User = DefaultUser
}
