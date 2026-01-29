import Vapor

// MARK: - Request DTOs

/// Request DTO for creating a new registration field
public struct CreateRegistrationFieldRequest: Content {
    public let fieldName: String
    public let fieldLabel: String
    public let fieldType: String
    public let isRequired: Bool
    public let displayOrder: Int
    public let isActive: Bool
    public let placeholder: String?
    public let helpText: String?
    public let validationPattern: String?
    public let options: String?

    public init(
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

/// Request DTO for updating an existing registration field
public struct UpdateRegistrationFieldRequest: Content {
    public let fieldLabel: String?
    public let fieldType: String?
    public let isRequired: Bool?
    public let displayOrder: Int?
    public let isActive: Bool?
    public let placeholder: String?
    public let helpText: String?
    public let validationPattern: String?
    public let options: String?

    public init(
        fieldLabel: String? = nil,
        fieldType: String? = nil,
        isRequired: Bool? = nil,
        displayOrder: Int? = nil,
        isActive: Bool? = nil,
        placeholder: String? = nil,
        helpText: String? = nil,
        validationPattern: String? = nil,
        options: String? = nil
    ) {
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

// MARK: - Response DTOs

/// Response DTO for registration field information
public struct RegistrationFieldResponse: Content {
    public let id: UUID
    public let fieldName: String
    public let fieldLabel: String
    public let fieldType: String
    public let isRequired: Bool
    public let displayOrder: Int
    public let isActive: Bool
    public let placeholder: String?
    public let helpText: String?
    public let validationPattern: String?
    public let options: [String]?
    public let createdAt: Date?
    public let updatedAt: Date?

    public init(
        id: UUID,
        fieldName: String,
        fieldLabel: String,
        fieldType: String,
        isRequired: Bool,
        displayOrder: Int,
        isActive: Bool,
        placeholder: String?,
        helpText: String?,
        validationPattern: String?,
        options: [String]?,
        createdAt: Date?,
        updatedAt: Date?
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
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

/// Simplified response DTO for public endpoints (excludes admin-only fields)
public struct PublicRegistrationFieldResponse: Content {
    public let fieldName: String
    public let fieldLabel: String
    public let fieldType: String
    public let isRequired: Bool
    public let displayOrder: Int
    public let placeholder: String?
    public let helpText: String?
    public let validationPattern: String?
    public let options: [String]?

    public init(
        fieldName: String,
        fieldLabel: String,
        fieldType: String,
        isRequired: Bool,
        displayOrder: Int,
        placeholder: String?,
        helpText: String?,
        validationPattern: String?,
        options: [String]?
    ) {
        self.fieldName = fieldName
        self.fieldLabel = fieldLabel
        self.fieldType = fieldType
        self.isRequired = isRequired
        self.displayOrder = displayOrder
        self.placeholder = placeholder
        self.helpText = helpText
        self.validationPattern = validationPattern
        self.options = options
    }
}

// MARK: - Helper Extensions

import Foundation

extension RegistrationFieldResponse {
    /// Parse options string to array
    private static func parseOptions(_ optionsString: String?) -> [String]? {
        guard let optionsString = optionsString,
              let data = optionsString.data(using: .utf8),
              let options = try? JSONDecoder().decode([String].self, from: data) else {
            return nil
        }
        return options
    }
}
