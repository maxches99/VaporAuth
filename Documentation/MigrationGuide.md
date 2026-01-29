# Migration Guide: BaseVapor → VaporAuth

This guide helps you migrate from BaseVapor to the new modular VaporAuth architecture.

## Overview

VaporAuth is the modular evolution of BaseVapor with several improvements:

✅ **Modular Architecture** - Use only what you need
✅ **Protocol-Oriented** - Flexible and extensible
✅ **Better Organization** - Separate modules for different features
✅ **Same API** - All endpoints remain unchanged

## Breaking Changes

### 1. Package Structure

**Before (BaseVapor):**
```swift
dependencies: [
    .package(path: "../") // Local BaseVapor
]
```

**After (VaporAuth):**
```swift
dependencies: [
    .package(url: "https://github.com/yourusername/VaporAuth.git", from: "1.0.0")
],
targets: [
    .target(dependencies: [
        .product(name: "VaporAuthCore", package: "VaporAuth"),
        .product(name: "VaporAuthOAuth", package: "VaporAuth"),
        .product(name: "VaporAuthAdmin", package: "VaporAuth"),
        .product(name: "VaporAuthFields", package: "VaporAuth"),
    ])
]
```

### 2. Imports

**Before:**
```swift
import BaseVapor
```

**After:**
```swift
import VaporAuthCore
import VaporAuthOAuth  // if using OAuth
import VaporAuthAdmin  // if using admin features
import VaporAuthFields // if using custom fields
```

### 3. Model Names

Models have been renamed for clarity:

| Before (BaseVapor) | After (VaporAuth) |
|-------------------|-------------------|
| `User` | `DefaultUser` |
| `UserToken` | `DefaultUserToken` |
| `OAuthProvider` | `DefaultOAuthProvider` |
| `UserCustomField` | `UserCustomField` (same) |
| `RegistrationField` | `RegistrationField` (same) |

### 4. Controller Registration

Controllers now use `Simple*` naming:

**Before:**
```swift
try app.register(collection: AuthController())
try app.register(collection: OAuthController())
```

**After:**
```swift
try app.register(collection: SimpleAuthController())
try app.register(collection: SimpleOAuthController())
```

### 5. Middleware

**Before:**
```swift
let protected = app.grouped(UserTokenAuthenticator())
```

**After:**
```swift
let protected = app.grouped(SimpleTokenAuthenticator())
```

## Step-by-Step Migration

### Step 1: Update Package.swift

```swift
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "YourApp",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.8.0"),
        .package(url: "https://github.com/yourusername/VaporAuth.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "Run",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                // VaporAuth modules
                .product(name: "VaporAuthCore", package: "VaporAuth"),
                .product(name: "VaporAuthOAuth", package: "VaporAuth"),
                .product(name: "VaporAuthAdmin", package: "VaporAuth"),
                .product(name: "VaporAuthFields", package: "VaporAuth"),
            ]
        )
    ]
)
```

### Step 2: Update Imports

Find and replace in all files:

```bash
# Find
import BaseVapor

# Replace with
import VaporAuthCore
import VaporAuthOAuth
import VaporAuthAdmin
import VaporAuthFields
```

Or selectively import only needed modules.

### Step 3: Update configure.swift

**Before:**
```swift
import BaseVapor

func configure(_ app: Application) async throws {
    // ... database config ...

    // Migrations
    app.migrations.add(CreateUser())
    app.migrations.add(CreateUserToken())
    app.migrations.add(CreateOAuthProvider())
    app.migrations.add(AddRoleToUser())
    app.migrations.add(CreateAdminUser())
    app.migrations.add(CreateRegistrationField())
    app.migrations.add(CreateUserCustomField())
    app.migrations.add(SeedDefaultRegistrationFields())
}
```

**After:**
```swift
import VaporAuthCore
import VaporAuthOAuth
import VaporAuthAdmin
import VaporAuthFields

func configure(_ app: Application) async throws {
    // ... database config ...

    // Core migrations
    app.migrations.add(CreateUserMigration<DefaultUser>())
    app.migrations.add(CreateTokenMigration<DefaultUserToken>())

    // OAuth migrations
    app.migrations.add(CreateOAuthProviderMigration())

    // Admin migrations
    app.migrations.add(CreateAdminUserMigration())

    // Fields migrations
    app.migrations.add(CreateRegistrationFieldMigration())
    app.migrations.add(CreateUserCustomFieldMigration())
    app.migrations.add(SeedDefaultFieldsMigration())
}
```

**Important Notes:**
- `AddRoleToUser` and `MakeUserPasswordOptional` migrations are **NOT needed** for fresh databases
- They're only for upgrading existing BaseVapor databases
- New installations already have these features built-in

### Step 4: Update routes.swift

**Before:**
```swift
import BaseVapor

func routes(_ app: Application) throws {
    try app.register(collection: AuthController())
    try app.register(collection: OAuthController())
    try app.register(collection: PublicRegistrationFieldsController())

    let admin = app.grouped(UserTokenAuthenticator())
        .grouped(AdminAuthMiddleware())
    try admin.register(collection: AdminRegistrationFieldsController())
}
```

**After:**
```swift
import VaporAuthCore
import VaporAuthOAuth
import VaporAuthAdmin
import VaporAuthFields

func routes(_ app: Application) throws {
    // Basic auth
    try app.register(collection: SimpleAuthController())

    // OAuth
    try app.register(collection: SimpleOAuthController())

    // Public fields
    try app.register(collection: PublicFieldsController())

    // Admin routes
    let admin = app.grouped(SimpleTokenAuthenticator())
        .grouped(AdminAuthMiddleware())
    try admin.register(collection: AdminFieldsController())
}
```

### Step 5: Database Migration (Existing Data)

If you have existing BaseVapor database:

#### Option A: Fresh Start (Recommended)
```bash
# Backup your data
pg_dump vapor_database > backup.sql

# Drop database
dropdb vapor_database
createdb vapor_database

# Run new migrations
swift run Run migrate --yes

# Restore data (manual mapping required)
```

#### Option B: In-Place Upgrade

Your existing database already has the correct schema. You just need to:

1. Skip these migrations (they're for upgrade only):
   - `AddRoleToUserMigration` (role field exists)
   - `MakeUserPasswordOptionalMigration` (password already optional)

2. Run new migrations:
```bash
swift run Run migrate --yes
```

The migration system will skip existing tables and only create new ones.

### Step 6: Update Custom Code

If you have custom code referencing BaseVapor models:

**Before:**
```swift
let user = User(email: "test@example.com", ...)
let token = UserToken(value: "token", userID: userID)
```

**After:**
```swift
let user = DefaultUser(email: "test@example.com", ...)
let token = DefaultUserToken(value: "token", userID: userID)
```

### Step 7: Test Your Application

```bash
# Resolve dependencies
swift package resolve

# Build
swift build

# Run tests (if you have them)
swift test

# Run application
swift run
```

### Step 8: Verify Endpoints

All API endpoints remain the same:

```bash
# Test registration
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"pass123","name":"Test"}'

# Test login
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"pass123"}'

# Test protected route
curl -X GET http://localhost:8080/auth/me \
  -H "Authorization: Bearer TOKEN"
```

## API Compatibility

✅ **All endpoints remain unchanged:**

### Authentication
- `POST /auth/register`
- `POST /auth/login`
- `GET /auth/me`
- `POST /auth/logout`

### OAuth
- `GET /auth/google`
- `GET /auth/google/callback`
- `GET /auth/providers`

### Registration Fields
- `GET /registration-fields`
- `GET /admin/registration-fields`
- `POST /admin/registration-fields`
- `PUT /admin/registration-fields/:id`
- `DELETE /admin/registration-fields/:id`

✅ **All request/response formats remain unchanged**

## Custom User Model Migration

If you created a custom User model in BaseVapor:

### Option 1: Keep Your Custom Model

Your custom model needs to conform to VaporAuth protocols:

```swift
import VaporAuthCore

final class User: Model {
    // Your existing fields
}

// Add protocol conformances
extension User: AuthenticatableUser {
    var hasPassword: Bool { passwordHash != nil }
}

extension User: PasswordAuthenticatable {
    // Uses default implementation
}

extension User: TokenGenerating {
    typealias Token = UserToken
    func generateToken() throws -> UserToken {
        try .init(value: [UInt8].random(count: 16).base64, userID: self.requireID())
    }
}

extension User: RoleAuthenticatable {
    // Uses default implementation
}

extension User: OAuthAuthenticatable {
    typealias OAuthProviderType = DefaultOAuthProvider
}

extension User: Authenticatable { }
```

### Option 2: Switch to DefaultUser

Migrate your data to DefaultUser:

1. Export existing user data
2. Drop old tables
3. Run VaporAuth migrations
4. Import data into new schema

## Troubleshooting

### "Module 'BaseVapor' not found"

**Solution:** Update all imports from `BaseVapor` to VaporAuth modules.

### "Type 'User' not found"

**Solution:** Replace `User` with `DefaultUser` or use your custom User model.

### "Controller not found"

**Solution:** Update controller names:
- `AuthController` → `SimpleAuthController`
- `OAuthController` → `SimpleOAuthController`
- `AdminRegistrationFieldsController` → `AdminFieldsController`
- `PublicRegistrationFieldsController` → `PublicFieldsController`

### Database migration errors

**Solution:** If upgrading existing database:
1. Backup your database first
2. Review migration errors carefully
3. Consider fresh start if issues persist

### Tests failing

**Solution:** Update test imports and model names to match new structure.

## Benefits of Migration

After migrating to VaporAuth:

✅ **Modular** - Only include features you need
✅ **Maintainable** - Better organized codebase
✅ **Extensible** - Protocol-based architecture
✅ **Up-to-date** - Active development
✅ **Documented** - Comprehensive guides
✅ **Examples** - Multiple working examples

## Rollback Plan

If you need to rollback:

1. Restore your `Package.swift` backup
2. Restore your code backups
3. Restore database backup
4. Run `swift package resolve`

## Need Help?

- 📖 [Documentation](./GettingStarted.md)
- 💬 [GitHub Discussions](https://github.com/yourusername/VaporAuth/discussions)
- 🐛 [Report Issues](https://github.com/yourusername/VaporAuth/issues)

## Migration Checklist

Use this checklist to track your migration:

- [ ] Backup database
- [ ] Update Package.swift
- [ ] Update imports
- [ ] Update model names
- [ ] Update controller registration
- [ ] Update middleware
- [ ] Run migrations
- [ ] Test all endpoints
- [ ] Verify OAuth flow (if using)
- [ ] Test admin features (if using)
- [ ] Check custom fields (if using)
- [ ] Update tests
- [ ] Deploy to staging
- [ ] Final production deployment

## Timeline

Typical migration time:
- **Small project (< 10 files):** 30 minutes
- **Medium project (10-50 files):** 1-2 hours
- **Large project (50+ files):** 2-4 hours

Most of the time is spent on:
1. Updating imports (10%)
2. Updating model/controller names (20%)
3. Testing (70%)
