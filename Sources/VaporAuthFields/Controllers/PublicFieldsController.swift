import Fluent
import Vapor

/// Public controller for retrieving active registration fields
/// No authentication required - used by registration forms
///
/// Usage:
/// ```swift
/// try app.register(collection: PublicFieldsController())
/// ```
public struct PublicFieldsController: RouteCollection {
    public init() {}

    public func boot(routes: any RoutesBuilder) throws {
        let fields = routes.grouped("registration-fields")
        fields.get(use: getActiveFields)
    }

    // MARK: - Public Endpoints

    /// Get all active registration fields
    /// GET /registration-fields
    public func getActiveFields(req: Request) async throws -> [PublicRegistrationFieldResponse] {
        let fields = try await RegistrationField.query(on: req.db)
            .filter(\.$isActive == true)
            .sort(\.$displayOrder)
            .all()

        return fields.map { field in
            PublicRegistrationFieldResponse(
                fieldName: field.fieldName,
                fieldLabel: field.fieldLabel,
                fieldType: field.fieldType,
                isRequired: field.isRequired,
                displayOrder: field.displayOrder,
                placeholder: field.placeholder,
                helpText: field.helpText,
                validationPattern: field.validationPattern,
                options: parseOptions(field.options)
            )
        }
    }

    // MARK: - Helper Methods

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
