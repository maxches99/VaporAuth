import Vapor

// MARK: - User Response

/// Response DTO for user information
public struct UserResponse: Content {
    public let id: UUID
    public let email: String
    public let name: String
    public let hasPassword: Bool

    public init(
        id: UUID,
        email: String,
        name: String,
        hasPassword: Bool
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.hasPassword = hasPassword
    }
}

// MARK: - Helper Extensions

extension AuthenticatableUser {
    /// Convert user to UserResponse
    public func toUserResponse() throws -> UserResponse {
        guard let id = self.id as? UUID else {
            throw Abort(.internalServerError, reason: "User ID must be UUID")
        }

        return UserResponse(
            id: id,
            email: self.email,
            name: self.name,
            hasPassword: self.hasPassword
        )
    }

    /// Convert user to AuthResponse with token
    public func toAuthResponse(token: String) throws -> AuthResponse {
        guard let id = self.id as? UUID else {
            throw Abort(.internalServerError, reason: "User ID must be UUID")
        }

        return AuthResponse(
            id: id,
            email: self.email,
            name: self.name,
            token: token,
            hasPassword: self.hasPassword
        )
    }
}
