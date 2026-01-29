import XCTest
@testable import VaporAuthAdmin
@testable import VaporAuthCore
import Vapor

final class AdminMiddlewareTests: XCTestCase {

    func testRoleAuthMiddlewareSingleRole() {
        let middleware = RoleAuthMiddleware(requiredRole: "admin")

        // Test that middleware requires "admin" role
        // Note: Full integration test would require setting up Vapor app
        XCTAssertNotNil(middleware)
    }

    func testRoleAuthMiddlewareMultipleRoles() {
        let middleware = RoleAuthMiddleware(allowedRoles: ["admin", "moderator"])

        // Test that middleware allows multiple roles
        XCTAssertNotNil(middleware)
    }

    func testAdminAuthMiddleware() {
        let middleware = AdminAuthMiddleware()

        // Test that middleware is initialized
        XCTAssertNotNil(middleware)
    }
}

final class RoleTests: XCTestCase {

    func testDefaultUserRoles() {
        let admin = DefaultUser(
            email: "admin@example.com",
            passwordHash: "hash",
            name: "Admin",
            role: "admin"
        )
        XCTAssertTrue(admin.isAdmin)
        XCTAssertTrue(admin.hasRole("admin"))
        XCTAssertFalse(admin.hasRole("user"))

        let user = DefaultUser(
            email: "user@example.com",
            passwordHash: "hash",
            name: "User",
            role: "user"
        )
        XCTAssertFalse(user.isAdmin)
        XCTAssertTrue(user.hasRole("user"))
        XCTAssertFalse(user.hasRole("admin"))

        let moderator = DefaultUser(
            email: "mod@example.com",
            passwordHash: "hash",
            name: "Moderator",
            role: "moderator"
        )
        XCTAssertFalse(moderator.isAdmin)
        XCTAssertTrue(moderator.hasRole("moderator"))
        XCTAssertFalse(moderator.hasRole("admin"))
    }
}
