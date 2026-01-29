import Vapor
import VaporAuthCore

// MARK: - OAuth Provider Response

/// Response DTO for OAuth provider information
public struct OAuthProviderResponse: Content {
    public let providerName: String
    public let providerEmail: String
    public let linkedAt: Date?

    public init(
        providerName: String,
        providerEmail: String,
        linkedAt: Date?
    ) {
        self.providerName = providerName
        self.providerEmail = providerEmail
        self.linkedAt = linkedAt
    }
}

// MARK: - Helper Extensions

extension DefaultOAuthProvider {
    /// Convert OAuth provider to response DTO
    public func toResponse() -> OAuthProviderResponse {
        OAuthProviderResponse(
            providerName: self.providerName,
            providerEmail: self.providerEmail,
            linkedAt: self.createdAt
        )
    }
}

// MARK: - Extended Auth Response with OAuth

/// Extended auth response that includes OAuth provider information
public struct ExtendedAuthResponse: Content {
    public let id: UUID
    public let email: String
    public let name: String
    public let token: String
    public let hasPassword: Bool
    public let oauthProviders: [String]

    public init(
        id: UUID,
        email: String,
        name: String,
        token: String,
        hasPassword: Bool,
        oauthProviders: [String]
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.token = token
        self.hasPassword = hasPassword
        self.oauthProviders = oauthProviders
    }
}

/// Extended user response that includes OAuth provider information
public struct ExtendedUserResponse: Content {
    public let id: UUID
    public let email: String
    public let name: String
    public let hasPassword: Bool
    public let oauthProviders: [String]

    public init(
        id: UUID,
        email: String,
        name: String,
        hasPassword: Bool,
        oauthProviders: [String]
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.hasPassword = hasPassword
        self.oauthProviders = oauthProviders
    }
}
