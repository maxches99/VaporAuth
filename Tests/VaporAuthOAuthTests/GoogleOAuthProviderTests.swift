import XCTest
@testable import VaporAuthOAuth
import Vapor

final class GoogleOAuthProviderTests: XCTestCase {

    func testBuildAuthorizationURL() throws {
        let provider = GoogleOAuthProvider()

        let url = try provider.buildAuthorizationURL(
            clientID: "test_client_id",
            redirectURI: "http://localhost:8080/auth/google/callback",
            state: "test_state"
        )

        XCTAssertTrue(url.contains("accounts.google.com/o/oauth2/v2/auth"))
        XCTAssertTrue(url.contains("client_id=test_client_id"))
        XCTAssertTrue(url.contains("redirect_uri=http://localhost:8080/auth/google/callback"))
        XCTAssertTrue(url.contains("response_type=code"))
        XCTAssertTrue(url.contains("state=test_state"))
        XCTAssertTrue(url.contains("access_type=offline"))
        XCTAssertTrue(url.contains("prompt=consent"))
    }

    func testBuildAuthorizationURLWithCustomScope() throws {
        let provider = GoogleOAuthProvider()

        let url = try provider.buildAuthorizationURL(
            clientID: "test_client_id",
            redirectURI: "http://localhost:8080/callback",
            scope: ["email", "profile", "openid"],
            state: "state123"
        )

        XCTAssertTrue(url.contains("scope=email%20profile%20openid") ||
                      url.contains("scope=email+profile+openid"))
    }

    func testGenerateState() {
        let provider = GoogleOAuthProvider()
        let state1 = provider.generateState()
        let state2 = provider.generateState()

        // States should be different (random)
        XCTAssertNotEqual(state1, state2)

        // State should not be empty
        XCTAssertFalse(state1.isEmpty)
        XCTAssertFalse(state2.isEmpty)
    }

    func testTokenResponseDecoding() throws {
        let json = """
        {
            "access_token": "test_access_token",
            "refresh_token": "test_refresh_token",
            "expires_in": 3600,
            "token_type": "Bearer"
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(GoogleOAuthProvider.TokenResponse.self, from: data)

        XCTAssertEqual(response.accessToken, "test_access_token")
        XCTAssertEqual(response.refreshToken, "test_refresh_token")
        XCTAssertEqual(response.expiresIn, 3600)
        XCTAssertEqual(response.tokenType, "Bearer")
    }

    func testUserInfoDecoding() throws {
        let json = """
        {
            "id": "12345",
            "email": "user@example.com",
            "name": "Test User",
            "picture": "https://example.com/photo.jpg"
        }
        """

        let data = json.data(using: .utf8)!
        let userInfo = try JSONDecoder().decode(GoogleOAuthProvider.UserInfo.self, from: data)

        XCTAssertEqual(userInfo.id, "12345")
        XCTAssertEqual(userInfo.email, "user@example.com")
        XCTAssertEqual(userInfo.name, "Test User")
        XCTAssertEqual(userInfo.picture, "https://example.com/photo.jpg")
    }
}
