import Fluent
import Vapor

// MARK: - Token Authentication Protocols

/// Protocol for token validation and authentication
/// Tokens conforming to this protocol can be used to authenticate requests
public protocol TokenAuthenticatable: Model, ModelTokenAuthenticatable {
    associatedtype User: AuthenticatableUser

    var value: String { get set }
    var expiresAt: Date { get set }

    /// Check if token is still valid (not expired)
    var isValid: Bool { get }
}

// MARK: - Default Implementations

extension TokenAuthenticatable {
    /// Default implementation checks if token hasn't expired
    public var isValid: Bool {
        expiresAt > Date()
    }
}
