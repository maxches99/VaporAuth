import Fluent
import Vapor
import VaporAuthCore

/// Simple OAuth service for DefaultUser and DefaultOAuthProvider
/// Handles finding or creating users during OAuth authentication
public struct SimpleOAuthService {
    public init() {}

    /// Find existing user by OAuth provider or create new one
    /// Also handles account linking if user with email already exists
    ///
    /// - Parameters:
    ///   - providerName: OAuth provider name (e.g., "google", "apple")
    ///   - providerUserID: User ID from OAuth provider
    ///   - email: Email from OAuth provider
    ///   - name: Name from OAuth provider
    ///   - accessToken: OAuth access token
    ///   - refreshToken: OAuth refresh token (optional)
    ///   - expiresAt: Token expiration date (optional)
    ///   - db: Database connection
    /// - Returns: User (existing or newly created)
    public func findOrCreateUser(
        providerName: String,
        providerUserID: String,
        email: String,
        name: String?,
        accessToken: String?,
        refreshToken: String?,
        expiresAt: Date?,
        on db: any Database
    ) async throws -> DefaultUser {
        // 1. Check if OAuth provider already exists (returning user)
        if let existingProvider = try await DefaultOAuthProvider.query(on: db)
            .filter(\.$providerName == providerName)
            .filter(\.$providerUserID == providerUserID)
            .with(\.$user)
            .first()
        {
            // Update tokens if changed
            var needsUpdate = false

            if let accessToken = accessToken, existingProvider.accessToken != accessToken {
                existingProvider.accessToken = accessToken
                needsUpdate = true
            }

            if let refreshToken = refreshToken, existingProvider.refreshToken != refreshToken {
                existingProvider.refreshToken = refreshToken
                needsUpdate = true
            }

            if let expiresAt = expiresAt, existingProvider.expiresAt != expiresAt {
                existingProvider.expiresAt = expiresAt
                needsUpdate = true
            }

            if needsUpdate {
                try await existingProvider.update(on: db)
            }

            return existingProvider.user
        }

        // 2. Check if user with this email exists (account linking)
        if let existingUser = try await DefaultUser.query(on: db)
            .filter(\.$email == email)
            .first()
        {
            // Link OAuth provider to existing user
            let provider = DefaultOAuthProvider(
                userID: try existingUser.requireID(),
                providerName: providerName,
                providerUserID: providerUserID,
                providerEmail: email,
                accessToken: accessToken,
                refreshToken: refreshToken,
                expiresAt: expiresAt
            )
            try await provider.save(on: db)

            return existingUser
        }

        // 3. Create new user (OAuth-only, no password)
        let newUser = DefaultUser(
            email: email,
            passwordHash: nil, // OAuth-only user
            name: name ?? email.components(separatedBy: "@")[0],
            role: "user"
        )
        try await newUser.save(on: db)

        // 4. Create OAuth provider record
        let provider = DefaultOAuthProvider(
            userID: try newUser.requireID(),
            providerName: providerName,
            providerUserID: providerUserID,
            providerEmail: email,
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: expiresAt
        )
        try await provider.save(on: db)

        return newUser
    }

    /// Link OAuth provider to existing user
    ///
    /// - Parameters:
    ///   - user: Existing user
    ///   - providerName: OAuth provider name
    ///   - providerUserID: User ID from OAuth provider
    ///   - email: Email from OAuth provider
    ///   - accessToken: OAuth access token
    ///   - refreshToken: OAuth refresh token (optional)
    ///   - expiresAt: Token expiration date (optional)
    ///   - db: Database connection
    /// - Returns: Created OAuth provider record
    public func linkProvider(
        user: DefaultUser,
        providerName: String,
        providerUserID: String,
        email: String,
        accessToken: String?,
        refreshToken: String?,
        expiresAt: Date?,
        on db: any Database
    ) async throws -> DefaultOAuthProvider {
        let provider = DefaultOAuthProvider(
            userID: try user.requireID(),
            providerName: providerName,
            providerUserID: providerUserID,
            providerEmail: email,
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: expiresAt
        )
        try await provider.save(on: db)
        return provider
    }

    /// Check if OAuth provider exists
    ///
    /// - Parameters:
    ///   - providerName: OAuth provider name
    ///   - providerUserID: User ID from OAuth provider
    ///   - db: Database connection
    /// - Returns: OAuth provider if found
    public func providerExists(
        providerName: String,
        providerUserID: String,
        on db: any Database
    ) async throws -> DefaultOAuthProvider? {
        try await DefaultOAuthProvider.query(on: db)
            .filter(\.$providerName == providerName)
            .filter(\.$providerUserID == providerUserID)
            .first()
    }

    /// Get all OAuth providers for a user
    ///
    /// - Parameters:
    ///   - user: User to get providers for
    ///   - db: Database connection
    /// - Returns: Array of OAuth providers
    public func getProviders(
        for user: DefaultUser,
        on db: any Database
    ) async throws -> [DefaultOAuthProvider] {
        try await DefaultOAuthProvider.query(on: db)
            .filter(\.$user.$id == user.requireID())
            .all()
    }
}
