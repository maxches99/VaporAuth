# Getting Started with VaporAuth

This guide will help you integrate VaporAuth into your Vapor application.

## Installation

### 1. Add Dependency

Add VaporAuth to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/VaporAuth.git", from: "1.0.0")
],
targets: [
    .target(
        name: "App",
        dependencies: [
            // Choose modules based on your needs:
            .product(name: "VaporAuthCore", package: "VaporAuth"),
            // Optional modules:
            // .product(name: "VaporAuthOAuth", package: "VaporAuth"),
            // .product(name: "VaporAuthAdmin", package: "VaporAuth"),
            // .product(name: "VaporAuthFields", package: "VaporAuth"),
        ]
    )
]
```

### 2. Resolve Dependencies

```bash
swift package resolve
```

## Quick Start (5 Minutes)

The fastest way to get started is using the default models:

### 1. Configure Database

```swift
// configure.swift
import Vapor
import Fluent
import FluentPostgresDriver
import VaporAuthCore

public func configure(_ app: Application) async throws {
    // Database
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "vapor",
        password: Environment.get("DATABASE_PASSWORD") ?? "password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_db"
    ), as: .psql)

    // Migrations
    app.migrations.add(CreateUserMigration<DefaultUser>())
    app.migrations.add(CreateTokenMigration<DefaultUserToken>())

    // Routes
    try routes(app)
}
```

### 2. Register Routes

```swift
// routes.swift
import Vapor
import VaporAuthCore

func routes(_ app: Application) throws {
    // Register authentication controller
    try app.register(collection: SimpleAuthController())
}
```

### 3. Run Migrations

```bash
swift run Run migrate --yes
```

### 4. Start Server

```bash
swift run
```

You now have these endpoints:
- `POST /auth/register` - Register new user
- `POST /auth/login` - Login
- `GET /auth/me` - Get current user (protected)
- `POST /auth/logout` - Logout (protected)

## Testing Your API

### Register a User

```bash
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "name": "John Doe"
  }'
```

Response:
```json
{
  "id": "uuid-here",
  "email": "user@example.com",
  "name": "John Doe",
  "token": "authentication-token"
}
```

### Login

```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

### Access Protected Endpoint

```bash
curl -X GET http://localhost:8080/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## Next Steps

### Add OAuth Authentication

See [OAuth Integration Guide](OAuthIntegration.md)

### Add Admin Roles

See [Admin Roles Guide](AdminRoles.md)

### Add Custom Fields

See [Custom Fields Guide](CustomFields.md)

### Use Custom User Model

See [Custom Models Guide](CustomModels.md)

## Module Selection Guide

Choose modules based on your requirements:

| Need | Use Modules | Example |
|------|-------------|---------|
| Basic auth only | Core | [MinimalAuthExample](../Examples/MinimalAuthExample/) |
| Auth + OAuth | Core + OAuth | [OAuthOnlyExample](../Examples/OAuthOnlyExample/) |
| Full featured app | All modules | [FullStackExample](../Examples/FullStackExample/) |

## Common Issues

### Database Connection Failed

**Error:** "Connection refused"

**Solution:** Make sure PostgreSQL is running:
```bash
docker run --name postgres -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres
```

### Migration Failed

**Error:** "relation already exists"

**Solution:** Either:
1. Drop the database and recreate
2. Or revert migrations: `swift run Run migrate --revert --yes`

### Token Not Valid

**Error:** 401 Unauthorized

**Solutions:**
1. Check token hasn't expired (30 days default)
2. Ensure correct Bearer token format: `Authorization: Bearer TOKEN`
3. Verify token exists in database

## Environment Variables

Create a `.env` file in your project root:

```env
# Database
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USERNAME=vapor_username
DATABASE_PASSWORD=vapor_password
DATABASE_NAME=vapor_database

# Optional: OAuth (if using VaporAuthOAuth)
GOOGLE_CLIENT_ID=your_client_id
GOOGLE_CLIENT_SECRET=your_client_secret
GOOGLE_CALLBACK_URL=http://localhost:8080/auth/google/callback

# Optional: Admin (if using VaporAuthAdmin)
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=admin123
ADMIN_NAME=Administrator
```

## Production Checklist

Before deploying to production:

- [ ] Change default database credentials
- [ ] Use strong admin password
- [ ] Set up HTTPS/TLS
- [ ] Configure production database
- [ ] Set appropriate token expiration
- [ ] Enable logging
- [ ] Set up monitoring
- [ ] Review security settings

## Support

- 📖 [Full Documentation](./README.md)
- 💬 [GitHub Discussions](https://github.com/yourusername/VaporAuth/discussions)
- 🐛 [Report Issues](https://github.com/yourusername/VaporAuth/issues)
