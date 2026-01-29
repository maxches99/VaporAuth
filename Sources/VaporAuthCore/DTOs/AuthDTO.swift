import Vapor

// MARK: - Registration

/// Request DTO for user registration
public struct RegisterRequest: Content {
    public let email: String
    public let password: String
    public let name: String

    public init(email: String, password: String, name: String) {
        self.email = email
        self.password = password
        self.name = name
    }
}

extension RegisterRequest: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
        validations.add("name", as: String.self, is: !.empty)
    }
}

// MARK: - Login

/// Request DTO for user login
public struct LoginRequest: Content {
    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

extension LoginRequest: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: !.empty)
    }
}

// MARK: - Response

/// Response DTO after successful authentication
public struct AuthResponse: Content {
    public let id: UUID
    public let email: String
    public let name: String
    public let token: String
    public let hasPassword: Bool

    public init(
        id: UUID,
        email: String,
        name: String,
        token: String,
        hasPassword: Bool
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.token = token
        self.hasPassword = hasPassword
    }
}
