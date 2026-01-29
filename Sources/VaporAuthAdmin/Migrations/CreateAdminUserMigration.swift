import Fluent
import Vapor
import VaporAuthCore

/// Migration to create the initial admin user
/// Reads admin credentials from environment variables
///
/// Required environment variables:
/// - ADMIN_EMAIL: Email for the admin user
/// - ADMIN_PASSWORD: Password for the admin user
/// - ADMIN_NAME: (Optional) Name for the admin user, defaults to "Administrator"
///
/// Usage:
/// ```swift
/// app.migrations.add(CreateAdminUserMigration())
/// ```
///
/// IMPORTANT: This migration should run after CreateUserMigration
public struct CreateAdminUserMigration: AsyncMigration {
    public init() {}

    public func prepare(on database: any Database) async throws {
        // Get admin credentials from environment
        guard let adminEmail = Environment.get("ADMIN_EMAIL"),
              let adminPassword = Environment.get("ADMIN_PASSWORD") else {
            // Skip if credentials not provided
            database.logger.warning("Skipping admin user creation: ADMIN_EMAIL or ADMIN_PASSWORD not set")
            return
        }

        let adminName = Environment.get("ADMIN_NAME") ?? "Administrator"

        // Check if admin user already exists
        let existingAdmin = try await DefaultUser.query(on: database)
            .filter(\.$email == adminEmail)
            .first()

        if existingAdmin != nil {
            database.logger.info("Admin user already exists: \(adminEmail)")
            return
        }

        // Create admin user
        let passwordHash = try Bcrypt.hash(adminPassword)
        let admin = DefaultUser(
            email: adminEmail,
            passwordHash: passwordHash,
            name: adminName,
            role: "admin"
        )

        try await admin.save(on: database)
        database.logger.info("Admin user created successfully: \(adminEmail)")
    }

    public func revert(on database: any Database) async throws {
        // Get admin email from environment
        guard let adminEmail = Environment.get("ADMIN_EMAIL") else {
            return
        }

        // Delete admin user
        try await DefaultUser.query(on: database)
            .filter(\.$email == adminEmail)
            .delete()

        database.logger.info("Admin user deleted: \(adminEmail)")
    }
}
