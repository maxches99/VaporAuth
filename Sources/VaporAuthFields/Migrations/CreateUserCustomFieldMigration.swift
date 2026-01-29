import Fluent
import Foundation

/// Migration to create user_custom_fields table
/// Stores user values for custom registration fields
public struct CreateUserCustomFieldMigration: AsyncMigration {
    public init() {}

    public func prepare(on database: any Database) async throws {
        try await database.schema("user_custom_fields")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("field_name", .string, .required)
            .field("field_value", .string, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "user_id", "field_name")
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema("user_custom_fields").delete()
    }
}
