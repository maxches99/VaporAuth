import Fluent
import Foundation

/// Migration to create oauth_providers table
/// Stores OAuth provider information for users
public struct CreateOAuthProviderMigration: AsyncMigration {
    public init() {}

    public func prepare(on database: any Database) async throws {
        try await database.schema("oauth_providers")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("provider_name", .string, .required)
            .field("provider_user_id", .string, .required)
            .field("provider_email", .string, .required)
            .field("access_token", .string)
            .field("refresh_token", .string)
            .field("expires_at", .datetime)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "provider_name", "provider_user_id")
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema("oauth_providers").delete()
    }
}
