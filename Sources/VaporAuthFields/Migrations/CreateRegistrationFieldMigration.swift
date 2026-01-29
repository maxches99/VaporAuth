import Fluent
import Foundation

/// Migration to create registration_fields table
/// Stores definitions for custom registration fields
public struct CreateRegistrationFieldMigration: AsyncMigration {
    public init() {}

    public func prepare(on database: any Database) async throws {
        try await database.schema("registration_fields")
            .id()
            .field("field_name", .string, .required)
            .field("field_label", .string, .required)
            .field("field_type", .string, .required)
            .field("is_required", .bool, .required)
            .field("display_order", .int, .required)
            .field("is_active", .bool, .required)
            .field("placeholder", .string)
            .field("help_text", .string)
            .field("validation_pattern", .string)
            .field("options", .string)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "field_name")
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema("registration_fields").delete()
    }
}
