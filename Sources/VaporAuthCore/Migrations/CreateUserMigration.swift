import Fluent
import Foundation

/// Generic migration to create users table
/// Works with any User type conforming to PasswordAuthenticatable
///
/// Usage:
/// ```swift
/// app.migrations.add(CreateUserMigration<User>())
/// ```
public struct CreateUserMigration<U: PasswordAuthenticatable & Model>: AsyncMigration
    where U.IDValue == UUID
{
    public init() {}

    public func prepare(on database: any Database) async throws {
        try await database.schema(U.schema)
            .id()
            .field("email", .string, .required)
            .field("password_hash", .string) // Optional for OAuth-only users
            .field("name", .string, .required)
            .field("created_at", .datetime)
            .unique(on: "email")
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(U.schema).delete()
    }
}

/// Convenience typealias for default implementation
public typealias DefaultCreateUserMigration = CreateUserMigration<DefaultUser>
