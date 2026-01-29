import Fluent
import Vapor
import VaporAuthCore
import VaporAuthAdmin

/// Admin controller for managing registration fields
/// Requires admin authentication
///
/// Usage:
/// ```swift
/// let adminRoutes = app.grouped(SimpleTokenAuthenticator())
///     .grouped(AdminAuthMiddleware())
/// try adminRoutes.register(collection: AdminFieldsController())
/// ```
public struct AdminFieldsController: RouteCollection {
    public init() {}

    public func boot(routes: any RoutesBuilder) throws {
        let fields = routes.grouped("admin", "registration-fields")

        fields.get(use: getAllFields)
        fields.post(use: createField)
        fields.get(":fieldID", use: getField)
        fields.put(":fieldID", use: updateField)
        fields.delete(":fieldID", use: deleteField)
    }

    // MARK: - Admin Endpoints

    /// Get all registration fields (including inactive)
    /// GET /admin/registration-fields
    public func getAllFields(req: Request) async throws -> [RegistrationFieldResponse] {
        let fields = try await RegistrationField.query(on: req.db)
            .sort(\.$displayOrder)
            .all()

        return fields.map { $0.toResponse() }
    }

    /// Get specific registration field
    /// GET /admin/registration-fields/:id
    public func getField(req: Request) async throws -> RegistrationFieldResponse {
        guard let field = try await RegistrationField.find(req.parameters.get("fieldID"), on: req.db) else {
            throw Abort(.notFound, reason: "Registration field not found")
        }

        return field.toResponse()
    }

    /// Create new registration field
    /// POST /admin/registration-fields
    public func createField(req: Request) async throws -> RegistrationFieldResponse {
        let input = try req.content.decode(CreateRegistrationFieldRequest.self)

        // Check if field name already exists
        let existing = try await RegistrationField.query(on: req.db)
            .filter(\.$fieldName == input.fieldName)
            .first()

        if existing != nil {
            throw Abort(.badRequest, reason: "Field with name '\(input.fieldName)' already exists")
        }

        // Validate field type
        let validTypes = ["text", "email", "number", "select", "checkbox", "textarea"]
        guard validTypes.contains(input.fieldType) else {
            throw Abort(.badRequest, reason: "Invalid field type. Must be one of: \(validTypes.joined(separator: ", "))")
        }

        // Create field
        let field = RegistrationField(
            fieldName: input.fieldName,
            fieldLabel: input.fieldLabel,
            fieldType: input.fieldType,
            isRequired: input.isRequired,
            displayOrder: input.displayOrder,
            isActive: input.isActive,
            placeholder: input.placeholder,
            helpText: input.helpText,
            validationPattern: input.validationPattern,
            options: input.options
        )

        try await field.save(on: req.db)
        return field.toResponse()
    }

    /// Update existing registration field
    /// PUT /admin/registration-fields/:id
    public func updateField(req: Request) async throws -> RegistrationFieldResponse {
        guard let field = try await RegistrationField.find(req.parameters.get("fieldID"), on: req.db) else {
            throw Abort(.notFound, reason: "Registration field not found")
        }

        let input = try req.content.decode(UpdateRegistrationFieldRequest.self)

        // Update fields if provided
        if let fieldLabel = input.fieldLabel {
            field.fieldLabel = fieldLabel
        }
        if let fieldType = input.fieldType {
            let validTypes = ["text", "email", "number", "select", "checkbox", "textarea"]
            guard validTypes.contains(fieldType) else {
                throw Abort(.badRequest, reason: "Invalid field type. Must be one of: \(validTypes.joined(separator: ", "))")
            }
            field.fieldType = fieldType
        }
        if let isRequired = input.isRequired {
            field.isRequired = isRequired
        }
        if let displayOrder = input.displayOrder {
            field.displayOrder = displayOrder
        }
        if let isActive = input.isActive {
            field.isActive = isActive
        }
        if let placeholder = input.placeholder {
            field.placeholder = placeholder
        }
        if let helpText = input.helpText {
            field.helpText = helpText
        }
        if let validationPattern = input.validationPattern {
            field.validationPattern = validationPattern
        }
        if let options = input.options {
            field.options = options
        }

        try await field.update(on: req.db)
        return field.toResponse()
    }

    /// Delete registration field
    /// DELETE /admin/registration-fields/:id
    public func deleteField(req: Request) async throws -> HTTPStatus {
        guard let field = try await RegistrationField.find(req.parameters.get("fieldID"), on: req.db) else {
            throw Abort(.notFound, reason: "Registration field not found")
        }

        try await field.delete(on: req.db)
        return .noContent
    }
}

// MARK: - Helper Extensions

extension RegistrationField {
    /// Convert model to response DTO
    func toResponse() -> RegistrationFieldResponse {
        RegistrationFieldResponse(
            id: self.id!,
            fieldName: self.fieldName,
            fieldLabel: self.fieldLabel,
            fieldType: self.fieldType,
            isRequired: self.isRequired,
            displayOrder: self.displayOrder,
            isActive: self.isActive,
            placeholder: self.placeholder,
            helpText: self.helpText,
            validationPattern: self.validationPattern,
            options: parseOptions(self.options),
            createdAt: self.createdAt,
            updatedAt: self.updatedAt
        )
    }

    /// Parse JSON array string to Swift array
    private func parseOptions(_ optionsString: String?) -> [String]? {
        guard let optionsString = optionsString,
              let data = optionsString.data(using: .utf8),
              let options = try? JSONDecoder().decode([String].self, from: data) else {
            return nil
        }
        return options
    }
}
