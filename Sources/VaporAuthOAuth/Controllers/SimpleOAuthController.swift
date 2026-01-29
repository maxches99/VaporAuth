import Fluent
import Vapor
import VaporAuthCore

/// Simple OAuth controller for Google authentication
/// Works with DefaultUser and DefaultOAuthProvider
///
/// Usage:
/// ```swift
/// try app.register(collection: SimpleOAuthController())
/// ```
public struct SimpleOAuthController: RouteCollection {
    private let oauthService = SimpleOAuthService()
    private let googleProvider = GoogleOAuthProvider()

    public init() {}

    public func boot(routes: any RoutesBuilder) throws {
        let oauth = routes.grouped("auth")

        // Google OAuth routes
        oauth.get("google", use: googleAuth)
        oauth.get("google", "callback", use: googleCallback)

        // Protected routes to manage OAuth providers
        let protected = oauth.grouped(SimpleTokenAuthenticator())
        protected.get("providers", use: getLinkedProviders)
    }

    // MARK: - Google OAuth

    /// Redirect to Google OAuth consent screen
    /// GET /auth/google
    public func googleAuth(req: Request) throws -> Response {
        let clientID = Environment.get("GOOGLE_CLIENT_ID") ?? ""
        let redirectURI = Environment.get("GOOGLE_CALLBACK_URL") ?? ""

        req.logger.info("Google OAuth - Client ID: \(clientID)")
        req.logger.info("Google OAuth - Redirect URI: \(redirectURI)")

        let redirect = try googleProvider.buildAuthorizationURL(
            clientID: clientID,
            redirectURI: redirectURI,
            state: googleProvider.generateState()
        )

        req.logger.info("Google OAuth - Full redirect URL: \(redirect)")
        return req.redirect(to: redirect)
    }

    /// Handle Google OAuth callback
    /// GET /auth/google/callback?code=...
    public func googleCallback(req: Request) async throws -> Response {
        do {
            req.logger.info("Google OAuth Callback - Start")

            // Get authorization code from query parameters
            guard let code = try? req.query.get(String.self, at: "code") else {
                req.logger.error("Google OAuth Callback - No authorization code")
                return req.redirect(to: "/?error=no_code&reason=No authorization code provided")
            }

            req.logger.info("Google OAuth Callback - Got code: \(code)")

            // Exchange code for access token
            req.logger.info("Google OAuth Callback - Exchanging code for token...")
            let tokenResponse = try await googleProvider.getAccessToken(
                code: code,
                clientID: Environment.get("GOOGLE_CLIENT_ID") ?? "",
                clientSecret: Environment.get("GOOGLE_CLIENT_SECRET") ?? "",
                redirectURI: Environment.get("GOOGLE_CALLBACK_URL") ?? "",
                on: req
            )

            req.logger.info("Google OAuth Callback - Got access token")

            // Get user info from Google
            req.logger.info("Google OAuth Callback - Getting user info...")
            let googleUser = try await googleProvider.getUserInfo(
                accessToken: tokenResponse.accessToken,
                on: req
            )

            req.logger.info("Google OAuth Callback - Got user info: \(googleUser.email)")

            // Use OAuthService to find or create user
            req.logger.info("Google OAuth Callback - Finding or creating user...")
            let user = try await oauthService.findOrCreateUser(
                providerName: "google",
                providerUserID: googleUser.id,
                email: googleUser.email,
                name: googleUser.name,
                accessToken: tokenResponse.accessToken,
                refreshToken: tokenResponse.refreshToken,
                expiresAt: tokenResponse.expiresAt,
                on: req.db
            )

            req.logger.info("Google OAuth Callback - User found/created: \(user.email)")

            // Generate app token
            req.logger.info("Google OAuth Callback - Generating token...")
            let token = try user.generateToken()
            try await token.save(on: req.db)

            req.logger.info("Google OAuth Callback - Success! Redirecting with token")

            // Redirect to frontend with token
            return req.redirect(to: "/?token=\(token.value)&source=google")
        } catch {
            req.logger.error("Google OAuth Callback - Error: \(error)")
            return req.redirect(to: "/?error=oauth_failed&reason=\(error.localizedDescription)")
        }
    }

    // MARK: - Protected Endpoints

    /// Get list of linked OAuth providers for current user
    /// GET /auth/providers
    /// Requires: Bearer token
    public func getLinkedProviders(req: Request) async throws -> [OAuthProviderResponse] {
        let user = try req.auth.require(DefaultUser.self)

        let providers = try await oauthService.getProviders(for: user, on: req.db)

        return providers.map { $0.toResponse() }
    }
}
