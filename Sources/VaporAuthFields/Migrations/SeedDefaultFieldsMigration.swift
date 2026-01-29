import Fluent
import Foundation

/// Migration to seed default registration fields
/// Creates common fields like phone, country, etc.
///
/// NOTE: This migration is optional. You can skip it and create
/// your own fields through the admin API instead.
public struct SeedDefaultFieldsMigration: AsyncMigration {
    public init() {}

    public func prepare(on database: any Database) async throws {
        // Default fields to create
        let defaultFields: [(name: String, label: String, type: String, order: Int)] = [
            ("phone", "Phone Number", "text", 1),
            ("country", "Country", "text", 2),
            ("company", "Company", "text", 3),
            ("job_title", "Job Title", "text", 4)
        ]

        // Create each field
        for fieldData in defaultFields {
            let field = RegistrationField(
                fieldName: fieldData.name,
                fieldLabel: fieldData.label,
                fieldType: fieldData.type,
                isRequired: false,
                displayOrder: fieldData.order,
                isActive: false, // Inactive by default - admin can enable them
                placeholder: nil,
                helpText: nil,
                validationPattern: nil,
                options: nil
            )
            try await field.save(on: database)
        }

        database.logger.info("Seeded \(defaultFields.count) default registration fields")
    }

    public func revert(on database: any Database) async throws {
        // Delete the seeded fields
        let fieldNames = ["phone", "country", "company", "job_title"]

        for fieldName in fieldNames {
            try await RegistrationField.query(on: database)
                .filter(\.$fieldName == fieldName)
                .delete()
        }

        database.logger.info("Removed default registration fields")
    }
}
