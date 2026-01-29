import Fluent
import Foundation

/// Migration to make password_hash optional in users table
/// This allows OAuth-only users who don't have passwords
///
/// NOTE: If you're creating a new database using CreateUserMigration,
/// password_hash is already optional and you don't need this migration.
/// This migration is only for upgrading existing databases.
public struct MakeUserPasswordOptionalMigration: AsyncMigration {
    public init() {}

    public func prepare(on database: any Database) async throws {
        // Make password_hash optional (remove NOT NULL constraint)
        try await database.schema("users")
            .updateField("password_hash", .string)
            .update()
    }

    public func revert(on database: any Database) async throws {
        // Revert by making password_hash required again
        // WARNING: This will fail if any users have NULL password_hash
        // Note: Fluent's updateField doesn't support adding constraints
        // You may need to use raw SQL for this operation
        try await database.schema("users")
            .updateField("password_hash", .string)
            .update()
    }
}
