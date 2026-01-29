import XCTest
@testable import VaporAuthCore
import Vapor

final class DefaultUserTests: XCTestCase {

    func testUserInitialization() {
        let user = DefaultUser(
            email: "test@example.com",
            passwordHash: "hashed_password",
            name: "Test User",
            role: "user"
        )

        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.passwordHash, "hashed_password")
        XCTAssertEqual(user.name, "Test User")
        XCTAssertEqual(user.role, "user")
    }

    func testHasPassword() {
        let userWithPassword = DefaultUser(
            email: "test@example.com",
            passwordHash: "hashed_password",
            name: "Test User"
        )
        XCTAssertTrue(userWithPassword.hasPassword)

        let userWithoutPassword = DefaultUser(
            email: "oauth@example.com",
            passwordHash: nil,
            name: "OAuth User"
        )
        XCTAssertFalse(userWithoutPassword.hasPassword)
    }

    func testPasswordVerification() throws {
        var user = DefaultUser(
            email: "test@example.com",
            passwordHash: nil,
            name: "Test User"
        )

        // Set a bcrypt hash for "password123"
        user.passwordHash = try Bcrypt.hash("password123")

        // Verify correct password
        XCTAssertTrue(try user.verify(password: "password123"))

        // Verify incorrect password
        XCTAssertFalse(try user.verify(password: "wrongpassword"))
    }

    func testIsAdmin() {
        let adminUser = DefaultUser(
            email: "admin@example.com",
            passwordHash: "hash",
            name: "Admin",
            role: "admin"
        )
        XCTAssertTrue(adminUser.isAdmin)

        let regularUser = DefaultUser(
            email: "user@example.com",
            passwordHash: "hash",
            name: "User",
            role: "user"
        )
        XCTAssertFalse(regularUser.isAdmin)
    }

    func testHasRole() {
        let moderator = DefaultUser(
            email: "mod@example.com",
            passwordHash: "hash",
            name: "Moderator",
            role: "moderator"
        )

        XCTAssertTrue(moderator.hasRole("moderator"))
        XCTAssertFalse(moderator.hasRole("admin"))
        XCTAssertFalse(moderator.hasRole("user"))
    }
}
