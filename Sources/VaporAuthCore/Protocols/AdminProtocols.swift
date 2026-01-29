import Vapor

// MARK: - Admin & Role Protocols

/// Protocol for role-based authorization
/// Users conforming to this can have roles assigned for access control
public protocol RoleAuthenticatable: AuthenticatableUser {
    var role: String { get set }

    /// Check if user has admin role
    var isAdmin: Bool { get }

    /// Check if user has specific role
    func hasRole(_ role: String) -> Bool
}

// MARK: - Default Implementations

extension RoleAuthenticatable {
    /// Default implementation checks if role is "admin"
    public var isAdmin: Bool {
        role == "admin"
    }

    /// Default implementation checks exact role match
    public func hasRole(_ roleName: String) -> Bool {
        self.role == roleName
    }
}
