# VaporAuth

Модульный фреймворк аутентификации для Vapor 4 с архитектурой на базе протоколов.

## 🎯 Обзор

VaporAuth - это модульная система аутентификации для Vapor, разработанная с использованием протокол-ориентированного подхода. Каждый модуль может использоваться независимо или в комбинации с другими.

## 🌐 Веб-интерфейс

В каждом примере приложения включен готовый веб-интерфейс для демонстрации возможностей:

### Главная страница (`index.html`)
- 📝 **Регистрация** с динамическими полями
  - Автоматическая загрузка полей из API
  - Поддержка различных типов полей (text, email, phone, date)
  - Валидация на стороне клиента
- 🔐 **Вход** с поддержкой OAuth (Google)
  - Традиционный вход по email/паролю
  - OAuth через Google с автоматическим редиректом
- 👤 **Профиль пользователя** с отображением кастомных полей
  - Просмотр всех данных пользователя
  - Отображение динамически добавленных полей
  - Управление токеном авторизации
- 🎨 Современный UI с градиентами и адаптивным дизайном
  - Responsive layout для мобильных устройств
  - Анимации и плавные переходы
  - Четкая визуализация статусов (success/error)

### Админ-панель (`admin.html`)
- ⚙️ **CRUD операции** для полей регистрации
  - Создание новых полей
  - Редактирование существующих
  - Удаление с подтверждением
- 🎛️ Настройка типов полей (text, email, phone, date)
- 🔄 Включение/выключение полей через toggle switch
- ✅ Управление валидацией и обязательностью полей
  - Regex паттерны для валидации
  - Placeholder тексты
- 📊 Изменение порядка отображения
- 🔒 Проверка прав администратора

**Технологии:**
- Vanilla JavaScript (без фреймворков)
- Fetch API для взаимодействия с backend
- LocalStorage для хранения токенов
- CSS Grid & Flexbox для layout
- Градиентные стили в духе современных UI-трендов

**Доступ:** Откройте `http://localhost:8080/` после запуска любого примера

## 📦 Модули

### VaporAuthCore
Базовый модуль с протоколами и default реализациями:
- ✅ `AuthenticatableUser` - базовая аутентификация
- ✅ `PasswordAuthenticatable` - аутентификация по паролю
- ✅ `TokenGenerating` - генерация токенов
- ✅ `TokenAuthenticatable` - валидация токенов
- ✅ `RoleAuthenticatable` - роли и права доступа
- ✅ `OAuthAuthenticatable` - OAuth интеграция
- ✅ `CustomFieldsUser` - кастомные поля
- ✅ `DefaultUser` - готовая реализация User
- ✅ `DefaultUserToken` - готовая реализация Token

### VaporAuthOAuth ✅
OAuth 2.0 аутентификация:
- ✅ Google OAuth provider
- ✅ Account linking
- ✅ OAuth-only users (без пароля)
- ✅ Multiple providers per user
- ✅ SimpleOAuthService
- ✅ SimpleOAuthController

### VaporAuthAdmin ✅
Админ функционал и управление ролями:
- ✅ AdminAuthMiddleware - проверка admin роли
- ✅ RoleAuthMiddleware - гибкая проверка ролей
- ✅ CreateAdminUserMigration
- ✅ AddRoleToUserMigration

### VaporAuthFields ✅
Динамические регистрационные поля:
- ✅ RegistrationField model
- ✅ UserCustomField model
- ✅ PublicFieldsController - публичный API
- ✅ AdminFieldsController - admin CRUD
- ✅ Field validation patterns
- ✅ Multiple field types (text, email, select, etc.)

## 🚀 Быстрый старт

### Установка

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/yourusername/VaporAuth.git", from: "1.0.0")
],
targets: [
    .target(
        name: "App",
        dependencies: [
            .product(name: "VaporAuth", package: "VaporAuth"), // Все модули
            // Или отдельные модули:
            // .product(name: "VaporAuthCore", package: "VaporAuth"),
            // .product(name: "VaporAuthOAuth", package: "VaporAuth"),
        ]
    )
]
```

### Использование Default реализаций (Самый быстрый способ)

```swift
import VaporAuthCore

// configure.swift
app.databases.use(.postgres(...), as: .psql)

// Миграции для default моделей
app.migrations.add(CreateUserMigration<DefaultUser>())
app.migrations.add(CreateTokenMigration<DefaultUserToken>())

try routes(app)

// routes.swift
try app.register(collection: SimpleAuthController())
```

Готово! У вас есть:
- `POST /auth/register` - регистрация
- `POST /auth/login` - логин
- `GET /auth/me` - текущий пользователь (protected)
- `POST /auth/logout` - выход (protected)

## 🔌 API Endpoints

### VaporAuthCore - Базовая аутентификация
```
POST   /auth/register          - Регистрация нового пользователя
POST   /auth/login             - Вход пользователя
GET    /auth/me                - Получить данные текущего пользователя (требуется токен)
POST   /auth/logout            - Выход из системы (требуется токен)
```

### VaporAuthOAuth - OAuth аутентификация
```
GET    /auth/google            - Начать OAuth flow с Google
GET    /auth/google/callback   - Callback для Google OAuth
```

### VaporAuthFields - Динамические поля
```
GET    /registration-fields              - Получить активные поля регистрации (публичный)
POST   /auth/register-dynamic            - Регистрация с кастомными полями
GET    /auth/me-extended                 - Получить профиль с кастомными полями (требуется токен)

# Admin endpoints (требуется admin роль)
GET    /admin/registration-fields        - Получить все поля
POST   /admin/registration-fields        - Создать новое поле
GET    /admin/registration-fields/:id    - Получить конкретное поле
PUT    /admin/registration-fields/:id    - Обновить поле
DELETE /admin/registration-fields/:id    - Удалить поле
```

### Создание своей User модели

Создайте свою модель, реализующую нужные протоколы:

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
}

// Protocol conformances
extension User: AuthenticatableUser {
    var hasPassword: Bool { passwordHash != nil }
}

extension User: PasswordAuthenticatable {
    // Использует default implementation
}

extension User: TokenGenerating {
    typealias Token = UserToken

    func generateToken() throws -> UserToken {
        try .init(value: [UInt8].random(count: 16).base64, userID: self.requireID())
    }
}

extension User: RoleAuthenticatable {
    // Использует default implementation
}

extension User: Authenticatable { }
```

## 🏗️ Архитектура

### Протокол-ориентированный дизайн

Все функции реализованы через протоколы:

```swift
// Базовая аутентификация
public protocol AuthenticatableUser: Model, Authenticatable {
    var id: IDValue? { get set }
    var email: String { get set }
    var name: String { get set }
    var hasPassword: Bool { get }
}

// Password authentication
public protocol PasswordAuthenticatable: AuthenticatableUser {
    var passwordHash: String? { get set }
    func verify(password: String) throws -> Bool
}

// Token generation
public protocol TokenGenerating {
    associatedtype Token: TokenAuthenticatable
    func generateToken() throws -> Token
}
```

### Generic Controllers

Контроллеры работают с любыми типами, реализующими протоколы:

```swift
public struct AuthController<U>: RouteCollection
    where U: PasswordAuthenticatable & TokenGenerating {

    public func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post("register", use: register)
        auth.post("login", use: login)
        // ...
    }
}
```

## 📖 Текущий статус реализации

### ✅ VaporAuthCore - ЗАВЕРШЕН!
- [x] Структура монорепозитория
- [x] Package.swift с 4 модулями
- [x] Все протоколы (Auth, Token, OAuth, Admin, CustomFields)
- [x] Default модели (DefaultUser, DefaultUserToken, DefaultOAuthProvider, UserCustomField)
- [x] SimpleAuthController (register, login, logout, me)
- [x] SimpleTokenAuthenticator middleware
- [x] DTOs (AuthDTO, UserDTO)
- [x] Generic Migrations (CreateUserMigration, CreateTokenMigration)
- [x] Успешная компиляция ✅
- [x] USAGE guide

### ✅ VaporAuthOAuth - ЗАВЕРШЕН!
- [x] DefaultOAuthProvider model
- [x] SimpleOAuthService (account linking logic)
- [x] GoogleOAuthProvider (полный OAuth 2.0 flow)
- [x] SimpleOAuthController (Google auth + callback)
- [x] OAuthDTO (response models)
- [x] Migrations (CreateOAuthProviderMigration, MakeUserPasswordOptionalMigration)
- [x] Успешная компиляция ✅

### ✅ VaporAuthAdmin - ЗАВЕРШЕН!
- [x] AdminAuthMiddleware
- [x] RoleAuthMiddleware
- [x] Migrations (AddRoleToUserMigration, CreateAdminUserMigration)
- [x] Успешная компиляция ✅

### ✅ VaporAuthFields - ЗАВЕРШЕН!
- [x] RegistrationField model
- [x] UserCustomField model (moved to Core)
- [x] PublicFieldsController
- [x] AdminFieldsController (full CRUD)
- [x] RegistrationFieldDTO
- [x] Migrations (CreateRegistrationField, CreateUserCustomField, SeedDefaultFields)
- [x] Успешная компиляция ✅

### ✅ Examples - ЗАВЕРШЕНЫ!
- [x] FullStackExample (все модули)
- [x] MinimalAuthExample (только Core)
- [x] OAuthOnlyExample (Core + OAuth)
- [x] README для каждого примера
- [x] Examples/README.md

### ✅ Веб-интерфейс - ЗАВЕРШЕН!
- [x] Главная страница с регистрацией и входом
- [x] Поддержка динамических полей регистрации
- [x] OAuth интеграция (Google)
- [x] Профиль пользователя с кастомными полями
- [x] Админ-панель для управления полями
- [x] CRUD операции для полей регистрации
- [x] Современный адаптивный дизайн
- [x] LocalStorage для хранения токенов

### 🚧 В разработке
- [ ] Тесты для всех модулей
- [ ] Детальная документация API
- [ ] Migration Guide (BaseVapor → VaporAuth)

## 📚 Примеры использования

Полные рабочие примеры доступны в папке [Examples/](Examples/):
- **[MinimalAuthExample](Examples/MinimalAuthExample/)** - только базовая аутентификация + веб-интерфейс
- **[OAuthOnlyExample](Examples/OAuthOnlyExample/)** - аутентификация + Google OAuth + веб-интерфейс
- **[FullStackExample](Examples/FullStackExample/)** - все модули + полный веб-интерфейс с админ-панелью

**Каждый пример включает:**
- ✅ Готовый backend с настроенными роутами
- 🌐 Веб-интерфейс для тестирования API
- 📝 Подробную документацию по запуску

### Быстрые примеры кода

### Минимальная настройка (5 минут)

```swift
import Vapor
import VaporAuthCore

// configure.swift
public func configure(_ app: Application) async throws {
    // Database
    app.databases.use(.postgres(...), as: .psql)

    // Migrations
    app.migrations.add(CreateUserMigration<DefaultUser>())
    app.migrations.add(CreateTokenMigration<DefaultUserToken>())

    try routes(app)
}

// routes.swift
func routes(_ app: Application) throws {
    try app.register(collection: SimpleAuthController())
}
```

### С OAuth (10 минут)

```swift
import VaporAuthCore
import VaporAuthOAuth

func routes(_ app: Application) throws {
    try app.register(collection: SimpleAuthController())
    try app.register(collection: SimpleOAuthController())
}
```

### Full-stack (15 минут)

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

    // Admin routes (protected)
    let admin = app.grouped(SimpleTokenAuthenticator())
        .grouped(AdminAuthMiddleware())
    try admin.register(collection: AdminFieldsController())
}
```

**Запуск и использование:**
1. Настройте переменные окружения для OAuth (опционально):
   ```bash
   export GOOGLE_CLIENT_ID="your-client-id"
   export GOOGLE_CLIENT_SECRET="your-client-secret"
   export GOOGLE_CALLBACK_URL="http://localhost:8080/auth/google/callback"
   ```
2. Запустите приложение: `swift run`
3. Откройте браузер: `http://localhost:8080/`
4. Используйте веб-интерфейс для тестирования
5. Для доступа к админ-панели (`/admin.html`):
   - Создайте admin пользователя через миграцию `CreateAdminUserMigration`
   - Или вручную установите роль `admin` в базе данных

## 🤝 Вклад в разработку

Все основные модули завершены! ✅

Следующие шаги:
1. ~~Завершить VaporAuthCore~~ ✅
2. ~~Реализовать VaporAuthOAuth~~ ✅
3. ~~Реализовать VaporAuthAdmin~~ ✅
4. ~~Реализовать VaporAuthFields~~ ✅
5. ~~Создать примеры приложений~~ ✅
6. Написать unit tests
7. Создать детальную документацию API
8. Migration guide (BaseVapor → VaporAuth)

## 📄 Лицензия

MIT License

## 🔗 Ссылки

- [Vapor Documentation](https://docs.vapor.codes)
- [Fluent Documentation](https://docs.vapor.codes/fluent/overview/)
- [Migration Guide](Documentation/MigrationGuide.md) (в разработке)

---

**Статус:** ✅ Все модули, примеры и веб-интерфейс готовы! | Версия: 1.0.0-beta
