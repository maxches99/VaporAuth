# VaporAuth Examples

This directory contains example applications demonstrating different VaporAuth configurations.

## Available Examples

### 1. MinimalAuthExample
**Modules:** VaporAuthCore only

The simplest possible setup - just email/password authentication.

**Use when:**
- You only need basic authentication
- Starting a new project and want to keep it simple
- Learning VaporAuth basics

**Features:**
- ✅ User registration
- ✅ Email/password login
- ✅ Token-based authentication
- ✅ Protected endpoints

[View MinimalAuthExample →](./MinimalAuthExample/)

---

### 2. OAuthOnlyExample
**Modules:** VaporAuthCore + VaporAuthOAuth

Email/password authentication plus OAuth integration (Google).

**Use when:**
- You want to offer social login
- Users prefer OAuth over passwords
- You need account linking

**Features:**
- ✅ Email/password authentication
- ✅ Google OAuth login
- ✅ Account linking
- ✅ OAuth-only users (no password required)
- ✅ List linked providers

[View OAuthOnlyExample →](./OAuthOnlyExample/)

---

### 3. FullStackExample
**Modules:** All VaporAuth modules

Complete example with all features enabled.

**Use when:**
- Building a production application
- Need admin functionality
- Want dynamic registration fields
- Need full feature set

**Features:**
- ✅ Email/password authentication
- ✅ Google OAuth integration
- ✅ Admin role management
- ✅ Dynamic custom registration fields
- ✅ Protected admin endpoints
- ✅ Field validation

[View FullStackExample →](./FullStackExample/)

---

## Quick Start

Each example can be run independently:

```bash
# Navigate to an example
cd MinimalAuthExample

# Start PostgreSQL (if not running)
docker run --name postgres -e POSTGRES_USER=vapor_username \
  -e POSTGRES_PASSWORD=vapor_password \
  -e POSTGRES_DB=vapor_database \
  -p 5432:5432 -d postgres

# Run migrations
swift run Run migrate --yes

# Start the server
swift run
```

Server will start at `http://localhost:8080`

## Choosing an Example

```
┌─────────────────────────────────────────────────────────────┐
│                    Choose Your Example                       │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  Need just basic auth?                                       │
│  → MinimalAuthExample                                        │
│    Simple email/password authentication                      │
│                                                               │
│  Want social login too?                                      │
│  → OAuthOnlyExample                                          │
│    Email/password + Google OAuth                             │
│                                                               │
│  Need admin features and custom fields?                      │
│  → FullStackExample                                          │
│    All features enabled                                      │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Module Comparison

| Feature | Minimal | OAuth | FullStack |
|---------|---------|-------|-----------|
| Email/Password Auth | ✅ | ✅ | ✅ |
| Google OAuth | ❌ | ✅ | ✅ |
| Account Linking | ❌ | ✅ | ✅ |
| Admin Roles | ❌ | ❌ | ✅ |
| Custom Fields | ❌ | ❌ | ✅ |
| **Modules Used** | Core | Core + OAuth | Core + OAuth + Admin + Fields |
| **Complexity** | Low | Medium | High |

## Common Setup Steps

All examples require:

1. **PostgreSQL database** (provided via Docker command above)
2. **Swift 6.0+**
3. **Vapor 4.115.0+**

Optional for OAuth examples:
- Google OAuth credentials (get from [Google Cloud Console](https://console.cloud.google.com/))

## Environment Variables

Each example has an `.env.example` file. Copy it to `.env` and update with your configuration:

```bash
cp .env.example .env
```

Common variables:
- `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USERNAME`, `DATABASE_PASSWORD`, `DATABASE_NAME`

OAuth examples also need:
- `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `GOOGLE_CALLBACK_URL`

FullStack example additionally needs:
- `ADMIN_EMAIL`, `ADMIN_PASSWORD`, `ADMIN_NAME`

## Testing

Each example includes curl commands in its README for testing the API endpoints.

Example:
```bash
# Register a user
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123","name":"John"}'

# Login
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'
```

## Architecture

Each example demonstrates:
- ✅ Clean separation of concerns
- ✅ Protocol-oriented design
- ✅ Modular architecture
- ✅ Best practices for Vapor 4

## Next Steps

1. **Choose an example** that matches your needs
2. **Follow its README** for detailed setup
3. **Explore the code** to understand the implementation
4. **Customize** for your use case

## Need Help?

- Check individual example READMEs for detailed instructions
- See [VaporAuth Documentation](../) for module details
- Review source code in each example
