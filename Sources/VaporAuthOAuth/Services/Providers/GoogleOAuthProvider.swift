import Vapor

/// Google OAuth 2.0 Provider
/// Handles Google OAuth flow and API calls
public struct GoogleOAuthProvider {
    public init() {}

    // MARK: - OAuth URLs

    private let authorizationURL = "https://accounts.google.com/o/oauth2/v2/auth"
    private let tokenURL = "https://oauth2.googleapis.com/token"
    private let userInfoURL = "https://www.googleapis.com/oauth2/v2/userinfo"

    // MARK: - Token Response

    public struct TokenResponse: Content {
        public let accessToken: String
        public let refreshToken: String?
        public let expiresIn: Int
        public let tokenType: String

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case refreshToken = "refresh_token"
            case expiresIn = "expires_in"
            case tokenType = "token_type"
        }

        public var expiresAt: Date {
            Date().addingTimeInterval(TimeInterval(expiresIn))
        }
    }

    // MARK: - User Info Response

    public struct UserInfo: Content {
        public let id: String
        public let email: String
        public let name: String
        public let picture: String?

        enum CodingKeys: String, CodingKey {
            case id, email, name, picture
        }
    }

    // MARK: - Build Authorization URL

    /// Build Google OAuth authorization URL
    ///
    /// - Parameters:
    ///   - clientID: Google OAuth client ID
    ///   - redirectURI: Callback URL
    ///   - scope: OAuth scopes (default: ["email", "profile"])
    ///   - state: CSRF protection state
    /// - Returns: Authorization URL string
    public func buildAuthorizationURL(
        clientID: String,
        redirectURI: String,
        scope: [String] = ["email", "profile"],
        state: String
    ) throws -> String {
        var components = URLComponents(string: authorizationURL)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: scope.joined(separator: " ")),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "access_type", value: "offline"),
            URLQueryItem(name: "prompt", value: "consent")
        ]
        return components.url!.absoluteString
    }

    // MARK: - Exchange Code for Token

    /// Exchange authorization code for access token
    ///
    /// - Parameters:
    ///   - code: Authorization code from callback
    ///   - clientID: Google OAuth client ID
    ///   - clientSecret: Google OAuth client secret
    ///   - redirectURI: Callback URL
    ///   - req: Vapor request
    /// - Returns: Token response with access token
    public func getAccessToken(
        code: String,
        clientID: String,
        clientSecret: String,
        redirectURI: String,
        on req: Request
    ) async throws -> TokenResponse {
        let response = try await req.client.post(URI(string: tokenURL)) { tokenReq in
            try tokenReq.content.encode([
                "code": code,
                "client_id": clientID,
                "client_secret": clientSecret,
                "redirect_uri": redirectURI,
                "grant_type": "authorization_code"
            ], as: .urlEncodedForm)
        }

        guard response.status == .ok else {
            throw Abort(.badRequest, reason: "Failed to get access token from Google")
        }

        return try response.content.decode(TokenResponse.self)
    }

    // MARK: - Get User Info

    /// Get user information from Google
    ///
    /// - Parameters:
    ///   - accessToken: Google OAuth access token
    ///   - req: Vapor request
    /// - Returns: User information from Google
    public func getUserInfo(
        accessToken: String,
        on req: Request
    ) async throws -> UserInfo {
        let response = try await req.client.get(URI(string: userInfoURL)) { userReq in
            userReq.headers.bearerAuthorization = BearerAuthorization(token: accessToken)
        }

        guard response.status == .ok else {
            throw Abort(.badRequest, reason: "Failed to get user info from Google")
        }

        return try response.content.decode(UserInfo.self)
    }

    // MARK: - Generate State

    /// Generate random state for CSRF protection
    ///
    /// - Returns: Random state string
    public func generateState() -> String {
        [UInt8].random(count: 16).base64
    }
}
