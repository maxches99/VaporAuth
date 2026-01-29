import Fluent
import Vapor
import VaporAuthCore

/// Model for configurable registration fields
/// Allows admins to dynamically define custom fields for user registration
public final class RegistrationField: Model, @unchecked Sendable {
    public static let schema = "registration_fields"

    @ID(key: .id)
    public var id: UUID?

    /// Internal field name (used in database/API)
    @Field(key: "field_name")
    public var fieldName: String

    /// Display label for the field (shown to users)
    @Field(key: "field_label")
    public var fieldLabel: String

    /// Field type: text, email, number, select, checkbox, textarea
    @Field(key: "field_type")
    public var fieldType: String

    /// Whether this field is required
    @Field(key: "is_required")
    public var isRequired: Bool

    /// Display order (lower numbers appear first)
    @Field(key: "display_order")
    public var displayOrder: Int

    /// Whether this field is currently active
    @Field(key: "is_active")
    public var isActive: Bool

    /// Placeholder text for the field (optional)
    @OptionalField(key: "placeholder")
    public var placeholder: String?

    /// Help text to display with the field (optional)
    @OptionalField(key: "help_text")
    public var helpText: String?

    /// Validation pattern (regex) for text fields (optional)
    @OptionalField(key: "validation_pattern")
    public var validationPattern: String?

    /// Options for select fields (JSON array, optional)
    /// Example: ["Option 1", "Option 2", "Option 3"]
    @OptionalField(key: "options")
    public var options: String?

    @Timestamp(key: "created_at", on: .create)
    public var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    public var updatedAt: Date?

    public init() { }

    public init(
        id: UUID? = nil,
        fieldName: String,
        fieldLabel: String,
        fieldType: String,
        isRequired: Bool = false,
        displayOrder: Int = 0,
        isActive: Bool = true,
        placeholder: String? = nil,
        helpText: String? = nil,
        validationPattern: String? = nil,
        options: String? = nil
    ) {
        self.id = id
        self.fieldName = fieldName
        self.fieldLabel = fieldLabel
        self.fieldType = fieldType
        self.isRequired = isRequired
        self.displayOrder = displayOrder
        self.isActive = isActive
        self.placeholder = placeholder
        self.helpText = helpText
        self.validationPattern = validationPattern
        self.options = options
    }
}

// MARK: - Protocol Conformance

extension RegistrationField: RegistrationFieldProtocol {
    // Conforms to protocol from VaporAuthCore
}
