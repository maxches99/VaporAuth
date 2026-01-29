# VaporAuthCore - Usage Guide

## ✅ Что работает

VaporAuthCore полностью реализован и готов к использованию!

### Компоненты

1. **Протоколы** ✅
   - `AuthenticatableUser` - базовая аутентификация
   - `PasswordAuthenticatable` - пароли с Bcrypt
   - `TokenGenerating` - генерация токенов
   - `TokenAuthenticatable` - валидация токенов
   - `RoleAuthenticatable` - роли (admin/user)
   - `OAuthAuthenticatable` - OAuth протоколы
   - `CustomFieldsUser` - кастомные поля

2. **Default реализации** ✅
   - `DefaultUser` - готовая User модель
   - `DefaultUserToken` - готовая Token модель

3. **Controllers** ✅
   - `SimpleAuthController` - регистрация, логин, logout, me

4. **Middleware** ✅
   - `SimpleTokenAuthenticator` - Bearer token authentication

5. **Migrations** ✅
   - `CreateUserMigration<U>` - создание users таблицы
   - `CreateTokenMigration<T>` - создание tokens таблицы

6. **DTOs** ✅
   - `RegisterRequest`, `LoginRequest`
   - `AuthResponse`, `UserResponse`

## 🚀 Быстрый старт

### 1. Добавить зависимость

```swift
// Package.swift
dependencies: [
    .package(path: "../VaporAuth")
],
targets: [
    .executableTarget(
        name: "App",
        dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "fluent"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
            .product(name: "VaporAuthCore", package: "VaporAuth"),
        ]
    )
]
```

### 2. Configure.swift

```swift
import Fluent
import FluentPostgresDriver
import Vapor
import VaporAuthCore

public func configure(_ app: Application) async throws {
    // Database
    app.databases.use(
        .postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init) ?? 5432,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database"
        ),
        as: .psql
    )

    // Migrations для DefaultUser и DefaultUserToken
    app.migrations.add(CreateUserMigration<DefaultUser>())
    app.migrations.add(CreateTokenMigration<DefaultUserToken>())

    // Routes
    try routes(app)
}
```

### 3. Routes.swift

```swift
import Vapor
import VaporAuthCore

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    // Register auth controller
    try app.register(collection: SimpleAuthController())
}
```

### 4. Запуск

```bash
# Run migrations
swift run App migrate

# Start server
swift run App serve
```

## 📡 API Endpoints

### Register
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
  "id": "uuid",
  "email": "user@example.com",
  "name": "John Doe",
  "token": "auth-token-here",
  "hasPassword": true
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

### Get Current User (Protected)
```bash
curl http://localhost:8080/auth/me \
  -H "Authorization: Bearer your-token-here"
```

### Logout (Protected)
```bash
curl -X POST http://localhost:8080/auth/logout \
  -H "Authorization: Bearer your-token-here"
```

## 🔧 Кастомизация

### Создание своей User модели

```swift
import Fluent
import Vapor
import VaporAuthCore

final class User: Model, @unchecked Sendable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "email")
    var email: String

    @OptionalField(key: "password_hash")
    var passwordHash: String?

    @Field(key: "name")
    var name: String

    @Field(key: "role")
    var role: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Children(for: \.$user)
    var tokens: [UserToken]

    init() { }

    init(email: String, passwordHash: String?, name: String, role: String = "user") {
        self.email = email
        self.passwordHash = passwordHash
        self.name = name
        self.role = role
    }
}

// Protocol conformances
extension User: AuthenticatableUser {
    var hasPassword: Bool { passwordHash != nil }
}

extension User: PasswordAuthenticatable {
    // Uses default Bcrypt implementation
}

extension User: TokenGenerating {
    typealias Token = UserToken

    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}

extension User: RoleAuthenticatable {
    var isAdmin: Bool { role == "admin" }
    func hasRole(_ role: String) -> Bool { self.role == role }
}

extension User: Authenticatable { }
```

### Создание своего AuthController

Скопируйте `SimpleAuthController.swift` и адаптируйте под свою User модель:

```swift
// Замените DefaultUser на User
// Замените DefaultUserToken на UserToken
// Добавьте дополнительную логику если нужно
```

## 🎯 Что дальше?

VaporAuthCore завершен! Следующие шаги:

1. **VaporAuthOAuth** - Google/Apple OAuth
2. **VaporAuthAdmin** - Admin middleware и управление
3. **VaporAuthFields** - Динамические поля регистрации
4. **Examples** - Полные примеры приложений

## 💡 Tips

1. **Используйте DefaultUser/DefaultUserToken** для быстрого старта
2. **Создайте свои модели** когда нужна кастомизация
3. **Скопируйте SimpleAuthController** как шаблон
4. **Протоколы дают гибкость** - реализуйте только то, что нужно

## 🐛 Known Limitations

1. Generic controllers не работают из-за ограничений Swift property wrappers с generics
2. Используйте Simple* версии как шаблоны для своих типов
3. Для сложной кастомизации создавайте свои контроллеры на основе Simple*

---

**Status:** ✅ VaporAuthCore v1.0.0 - Production Ready
