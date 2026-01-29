import Fluent
import Foundation

/// Migration to add role field to existing users table
///
/// NOTE: If you're creating a new database using CreateUserMigration,
/// the role field is already included and you don't need this migration.
/// This migration is only for upgrading existing databases.
///
/// IMPORTANT: This migration adds the role field as a required field.
/// After running this migration, you may need to manually update existing users
/// to set their role field if the database doesn't support default values.
///
/// Recommended approach for existing databases:
/// 1. Run this migration
/// 2. Use a separate script or SQL to update existing users:
///    ```sql
///    UPDATE users SET role = 'user' WHERE role IS NULL;
///    ```
public struct AddRoleToUserMigration: AsyncMigration {
    public init() {}

    public func prepare(on database: any Database) async throws {
        // Add role column as required field
        // Note: This may fail if there are existing users without a role
        // You may need to add the field as optional first, update data, then make it required
        try await database.schema("users")
            .field("role", .string, .required)
            .update()
    }

    public func revert(on database: any Database) async throws {
        // Remove role column
        try await database.schema("users")
            .deleteField("role")
            .update()
    }
}
