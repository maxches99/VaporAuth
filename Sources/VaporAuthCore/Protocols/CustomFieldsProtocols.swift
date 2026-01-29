import Fluent
import Vapor

// MARK: - Custom Fields Protocols

/// Protocol for users with custom fields
/// Users conforming to this can have dynamic custom fields attached
public protocol CustomFieldsUser: AuthenticatableUser {
    associatedtype CustomField: CustomFieldProtocol where CustomField.User == Self

    var customFields: [CustomField] { get set }
}

/// Protocol for custom field definitions
/// Defines configuration for registration/profile fields
public protocol RegistrationFieldProtocol: Model {
    var fieldName: String { get set }
    var fieldLabel: String { get set }
    var fieldType: String { get set }
    var isRequired: Bool { get set }
    var isActive: Bool { get set }
    var displayOrder: Int { get set }
    var validationPattern: String? { get set }
    var placeholder: String? { get set }
}

/// Protocol for user's custom field values
/// Stores actual user data for custom fields
public protocol CustomFieldProtocol: Model {
    associatedtype User: CustomFieldsUser where User.CustomField == Self

    var fieldName: String { get set }
    var fieldValue: String { get set }
}
