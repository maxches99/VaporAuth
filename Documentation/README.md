# VaporAuth Documentation

Complete documentation for the VaporAuth modular authentication framework.

## 📚 Documentation Index

### Getting Started

- **[Getting Started Guide](./GettingStarted.md)** - Quick start guide for new users
- **[Migration Guide](./MigrationGuide.md)** - Migrate from BaseVapor to VaporAuth
- **[API Reference](./API.md)** - Complete API documentation

### Examples

See [Examples/](../Examples/) directory for working examples:
- **[MinimalAuthExample](../Examples/MinimalAuthExample/)** - Basic authentication only
- **[OAuthOnlyExample](../Examples/OAuthOnlyExample/)** - Auth + OAuth
- **[FullStackExample](../Examples/FullStackExample/)** - All features

## 🎯 Quick Links

### By Use Case

| I want to... | Read this |
|--------------|-----------|
| Get started quickly | [Getting Started](./GettingStarted.md) |
| Migrate from BaseVapor | [Migration Guide](./MigrationGuide.md) |
| See all API endpoints | [API Reference](./API.md) |
| See working examples | [Examples](../Examples/) |
| Understand the architecture | [Main README](../README.md) |

### By Module

| Module | Description | Documentation |
|--------|-------------|---------------|
| **VaporAuthCore** | Email/password authentication | [Getting Started](./GettingStarted.md#quick-start-5-minutes) |
| **VaporAuthOAuth** | OAuth integration (Google) | [OAuth Example](../Examples/OAuthOnlyExample/) |
| **VaporAuthAdmin** | Role-based access control | [FullStack Example](../Examples/FullStackExample/) |
| **VaporAuthFields** | Dynamic registration fields | [FullStack Example](../Examples/FullStackExample/) |

## 📖 Documentation Sections

### 1. Getting Started

**[→ Read Getting Started Guide](./GettingStarted.md)**

Learn how to:
- Install VaporAuth
- Set up your first authentication system
- Test your API endpoints
- Add OAuth, admin, or custom fields

**Time required:** 5-15 minutes depending on features needed

### 2. API Reference

**[→ Read API Documentation](./API.md)**

Complete reference for all endpoints:
- Authentication API (register, login, logout, me)
- OAuth API (Google integration)
- Admin API (manage registration fields)
- Public Fields API
- Error responses and status codes

### 3. Migration Guide

**[→ Read Migration Guide](./MigrationGuide.md)**

Upgrading from BaseVapor?
- Step-by-step migration process
- Breaking changes explained
- Database migration strategies
- Troubleshooting common issues

**Migration time:** 30 minutes - 4 hours depending on project size

## 🎓 Learning Path

### Beginner Path

1. Start with [Getting Started Guide](./GettingStarted.md)
2. Run [MinimalAuthExample](../Examples/MinimalAuthExample/)
3. Review [API Reference](./API.md) basics
4. Build your first authenticated endpoint

### Intermediate Path

1. Complete Beginner Path
2. Add OAuth with [OAuthOnlyExample](../Examples/OAuthOnlyExample/)
3. Implement custom fields
4. Add role-based access control

### Advanced Path

1. Complete Intermediate Path
2. Create custom User model
3. Implement custom middleware
4. Extend with additional OAuth providers
5. Add custom validation rules

## 🔍 Common Topics

### Authentication

- **Basic Auth:** Email + password authentication
  - [Getting Started](./GettingStarted.md)
  - [POST /auth/register](./API.md#post-authregister)
  - [POST /auth/login](./API.md#post-authlogin)

- **OAuth:** Social login integration
  - [OAuthOnlyExample](../Examples/OAuthOnlyExample/)
  - [GET /auth/google](./API.md#get-authgoogle)

- **Token Auth:** Bearer token authentication
  - [GET /auth/me](./API.md#get-authme)
  - [POST /auth/logout](./API.md#post-authlogout)

### Authorization

- **Admin Roles:** Role-based access control
  - [FullStackExample](../Examples/FullStackExample/)
  - `AdminAuthMiddleware`
  - `RoleAuthMiddleware`

### Custom Fields

- **Dynamic Fields:** Configurable registration fields
  - [GET /registration-fields](./API.md#get-registration-fields)
  - [Admin Fields API](./API.md#admin-api)

### Database

- **Migrations:** Database setup
  - [Getting Started - Migrations](./GettingStarted.md#1-configure-database)
  - [Migration Guide](./MigrationGuide.md#step-5-database-migration-existing-data)

- **Models:** User and Token models
  - `DefaultUser`
  - `DefaultUserToken`
  - `DefaultOAuthProvider`

## 🛠️ Troubleshooting

### Quick Fixes

| Problem | Solution | Documentation |
|---------|----------|---------------|
| Can't connect to database | Check PostgreSQL is running | [Getting Started - Common Issues](./GettingStarted.md#common-issues) |
| Token not working | Check expiration and format | [API - Authentication Headers](./API.md#authentication-headers) |
| Migration failed | Review migration errors | [Migration Guide](./MigrationGuide.md#troubleshooting) |
| Import errors | Check module imports | [Migration Guide](./MigrationGuide.md#step-2-update-imports) |

### Detailed Troubleshooting

- [Getting Started - Common Issues](./GettingStarted.md#common-issues)
- [Migration Guide - Troubleshooting](./MigrationGuide.md#troubleshooting)

## 📦 Module Documentation

### VaporAuthCore

**What it provides:**
- Email/password authentication
- Token generation and validation
- Default User and Token models
- Authentication protocols

**Key Components:**
- `DefaultUser` - User model with all features
- `DefaultUserToken` - 30-day auth token
- `SimpleAuthController` - Auth endpoints
- `SimpleTokenAuthenticator` - Token middleware

**Endpoints:**
- `POST /auth/register`
- `POST /auth/login`
- `GET /auth/me`
- `POST /auth/logout`

### VaporAuthOAuth

**What it provides:**
- Google OAuth 2.0 integration
- Account linking
- OAuth-only users
- Token management

**Key Components:**
- `DefaultOAuthProvider` - OAuth provider model
- `SimpleOAuthService` - Account linking logic
- `GoogleOAuthProvider` - Google OAuth implementation
- `SimpleOAuthController` - OAuth endpoints

**Endpoints:**
- `GET /auth/google`
- `GET /auth/google/callback`
- `GET /auth/providers`

### VaporAuthAdmin

**What it provides:**
- Role-based access control
- Admin middleware
- Admin user creation

**Key Components:**
- `AdminAuthMiddleware` - Admin-only access
- `RoleAuthMiddleware` - Custom role checking
- `CreateAdminUserMigration` - Create admin user

### VaporAuthFields

**What it provides:**
- Dynamic registration fields
- Field validation
- Admin field management
- Public field API

**Key Components:**
- `RegistrationField` - Field configuration model
- `UserCustomField` - User field values
- `PublicFieldsController` - Public API
- `AdminFieldsController` - Admin CRUD

**Endpoints:**
- `GET /registration-fields` (public)
- `GET /admin/registration-fields` (admin)
- `POST /admin/registration-fields` (admin)
- `PUT /admin/registration-fields/:id` (admin)
- `DELETE /admin/registration-fields/:id` (admin)

## 🧪 Testing

### Unit Tests

All modules include unit tests:

```bash
# Run all tests
swift test

# Run specific module tests
swift test --filter VaporAuthCoreTests
swift test --filter VaporAuthOAuthTests
swift test --filter VaporAuthAdminTests
swift test --filter VaporAuthFieldsTests
```

### Integration Testing

See examples for integration test patterns:
- [MinimalAuthExample](../Examples/MinimalAuthExample/)
- [OAuthOnlyExample](../Examples/OAuthOnlyExample/)
- [FullStackExample](../Examples/FullStackExample/)

## 🚀 Production Deployment

### Pre-deployment Checklist

- [ ] Change default credentials
- [ ] Set up HTTPS/TLS
- [ ] Configure production database
- [ ] Set token expiration
- [ ] Enable logging
- [ ] Set up monitoring
- [ ] Review security settings
- [ ] Test OAuth flows
- [ ] Backup strategy

### Environment Variables

Required for production:
```env
DATABASE_HOST=prod-db.example.com
DATABASE_USERNAME=prod_user
DATABASE_PASSWORD=strong_password
ADMIN_PASSWORD=very_strong_password
GOOGLE_CLIENT_ID=prod_client_id
GOOGLE_CLIENT_SECRET=prod_client_secret
```

See [Getting Started - Environment Variables](./GettingStarted.md#environment-variables)

## 📞 Support & Community

### Get Help

- 📖 **Documentation:** You're reading it!
- 💬 **GitHub Discussions:** Ask questions
- 🐛 **Issues:** Report bugs
- 📧 **Email:** support@example.com

### Contributing

Want to contribute?
1. Fork the repository
2. Create feature branch
3. Add tests
4. Submit pull request

### Reporting Issues

When reporting issues, include:
- VaporAuth version
- Swift version
- Operating system
- Steps to reproduce
- Error messages
- Expected vs actual behavior

## 📄 License

VaporAuth is released under the MIT License.

---

**Need more help?**

- Start with [Getting Started](./GettingStarted.md)
- Check [API Reference](./API.md) for endpoints
- Browse [Examples](../Examples/) for code samples
- Join [GitHub Discussions](https://github.com/yourusername/VaporAuth/discussions)
