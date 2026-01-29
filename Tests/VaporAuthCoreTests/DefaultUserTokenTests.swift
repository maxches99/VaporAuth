import XCTest
@testable import VaporAuthCore
import Vapor
import Foundation

final class DefaultUserTokenTests: XCTestCase {

    func testTokenInitialization() throws {
        let userID = UUID()
        let token = try DefaultUserToken(
            value: "test_token_value",
            userID: userID
        )

        XCTAssertEqual(token.value, "test_token_value")
        XCTAssertEqual(token.$user.id, userID)
    }

    func testTokenExpiration() throws {
        let userID = UUID()
        let token = try DefaultUserToken(
            value: "test_token",
            userID: userID
        )

        // Token should be valid initially
        XCTAssertTrue(token.isValid)

        // Manually set expiration to past
        var expiredToken = try DefaultUserToken(
            value: "expired_token",
            userID: userID
        )
        expiredToken.expiresAt = Date().addingTimeInterval(-1) // 1 second ago

        XCTAssertFalse(expiredToken.isValid)
    }

    func testTokenExpirationDate() throws {
        let userID = UUID()
        let token = try DefaultUserToken(
            value: "test_token",
            userID: userID
        )

        // Token should expire in approximately 30 days
        let expectedExpiration = Date().addingTimeInterval(60 * 60 * 24 * 30)
        let timeDifference = abs(token.expiresAt.timeIntervalSince(expectedExpiration))

        // Allow 1 second difference for test execution time
        XCTAssertLessThan(timeDifference, 1.0)
    }
}
