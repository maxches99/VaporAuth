import Fluent
import Vapor

/// Simple non-generic authentication controller for DefaultUser
/// Use this as a template for creating your own auth controller
///
/// Usage:
/// ```swift
/// try app.register(collection: SimpleAuthController())
/// ```
public struct SimpleAuthController: RouteCollection {
    public init() {}

    public func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")

        // Public routes
        auth.post("register", use: register)
        auth.post("login", use: login)

        // Protected routes
        let tokenProtected = auth.grouped(DefaultTokenAuthenticator())
        tokenProtected.get("me", use: getCurrentUser)
        tokenProtected.post("logout", use: logout)
    }

    // MARK: - Public Endpoints

    /// Register new user
    /// POST /auth/register
    public func register(req: Request) async throws -> AuthResponse {
        try RegisterRequest.validate(content: req)
        let registerRequest = try req.content.decode(RegisterRequest.self)

        // Check if user already exists
        if let _ = try await DefaultUser.query(on: req.db)
            .filter(\.$email == registerRequest.email)
            .first()
        {
            throw Abort(.badRequest, reason: "A user with this email already exists")
        }

        // Create user with hashed password
        let user = DefaultUser(
            email: registerRequest.email,
            passwordHash: try Bcrypt.hash(registerRequest.password),
            name: registerRequest.name
        )

        try await user.save(on: req.db)

        // Generate token
        let token = try user.generateToken()
        try await token.save(on: req.db)

        // Return auth response
        return try user.toAuthResponse(token: token.value)
    }

    /// Login with email and password
    /// POST /auth/login
    public func login(req: Request) async throws -> AuthResponse {
        try LoginRequest.validate(content: req)
        let loginRequest = try req.content.decode(LoginRequest.self)

        // Find user by email
        guard let user = try await DefaultUser.query(on: req.db)
            .filter(\.$email == loginRequest.email)
            .first()
        else {
            throw Abort(.unauthorized, reason: "Invalid email or password")
        }

        // Verify password
        guard try user.verify(password: loginRequest.password) else {
            throw Abort(.unauthorized, reason: "Invalid email or password")
        }

        // Generate token
        let token = try user.generateToken()
        try await token.save(on: req.db)

        // Return auth response
        return try user.toAuthResponse(token: token.value)
    }

    // MARK: - Protected Endpoints

    /// Get current user information
    /// GET /auth/me
    /// Requires: Bearer token
    public func getCurrentUser(req: Request) async throws -> UserResponse {
        let user = try req.auth.require(DefaultUser.self)
        return try user.toUserResponse()
    }

    /// Logout current user (delete all tokens)
    /// POST /auth/logout
    /// Requires: Bearer token
    public func logout(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(DefaultUser.self)

        // Delete all user's tokens
        try await DefaultUserToken.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .delete()

        return .noContent
    }
}
