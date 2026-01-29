import Fluent
import Vapor

// MARK: - Base Authentication Protocols

/// Base protocol for all authenticatable users
/// This protocol defines the minimum requirements for a user that can be authenticated
public protocol AuthenticatableUser: Model, Authenticatable {
    associatedtype IDValue: Codable, Hashable

    var id: IDValue? { get set }
    var email: String { get set }
    var name: String { get set }
    var createdAt: Date? { get set }

    /// Check if user has a password set (for OAuth-only users)
    var hasPassword: Bool { get }
}

/// Protocol for password-based authentication
/// Extends AuthenticatableUser with password verification capability
public protocol PasswordAuthenticatable: AuthenticatableUser {
    var passwordHash: String? { get set }

    /// Verify password against stored hash
    /// - Parameter password: Plain text password to verify
    /// - Returns: true if password matches, false otherwise
    /// - Throws: If there's an error during verification (e.g., invalid hash format)
    func verify(password: String) throws -> Bool
}

/// Protocol for token generation
/// Users conforming to this protocol can generate authentication tokens
public protocol TokenGenerating {
    associatedtype Token: TokenAuthenticatable

    /// Generate authentication token for this user
    /// - Returns: A new token for authentication
    /// - Throws: If token generation fails (e.g., user ID not set)
    func generateToken() throws -> Token
}

// MARK: - Default Implementations

extension PasswordAuthenticatable {
    /// Default implementation for password verification using Bcrypt
    public func verify(password: String) throws -> Bool {
        guard let hash = self.passwordHash else {
            return false
        }
        return try Bcrypt.verify(password, created: hash)
    }
}

extension AuthenticatableUser {
    /// Default hasPassword implementation
    /// Override this in your model if you need custom logic
    public var hasPassword: Bool {
        if let self = self as? PasswordAuthenticatable {
            return self.passwordHash != nil
        }
        return false
    }
}
