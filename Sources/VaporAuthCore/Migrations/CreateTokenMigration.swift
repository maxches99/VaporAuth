import Fluent
import Foundation

/// Generic migration to create user tokens table
/// Works with any Token type conforming to TokenAuthenticatable
///
/// Usage:
/// ```swift
/// app.migrations.add(CreateTokenMigration<UserToken>())
/// ```
public struct CreateTokenMigration<T: TokenAuthenticatable & Model>: AsyncMigration
    where T.IDValue == UUID,
          T.User: Model,
          T.User.IDValue == UUID
{
    public init() {}

    public func prepare(on database: any Database) async throws {
        try await database.schema(T.schema)
            .id()
            .field("value", .string, .required)
            .field("user_id", .uuid, .required, .references(T.User.schema, "id", onDelete: .cascade))
            .field("created_at", .datetime)
            .field("expires_at", .datetime, .required)
            .unique(on: "value")
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(T.schema).delete()
    }
}

/// Convenience typealias for default implementation
public typealias DefaultCreateTokenMigration = CreateTokenMigration<DefaultUserToken>
