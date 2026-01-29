# FullStackExample

Complete example demonstrating all VaporAuth modules working together:
- **VaporAuthCore**: Email/password authentication
- **VaporAuthOAuth**: Google OAuth integration
- **VaporAuthAdmin**: Role-based access control
- **VaporAuthFields**: Dynamic registration fields

## Features

- ✅ User registration with email and password
- ✅ User login and token-based authentication
- ✅ Google OAuth authentication
- ✅ Admin role management
- ✅ Dynamic custom registration fields
- ✅ Protected admin endpoints

## Setup

1. **Copy environment variables:**
   ```bash
   cp .env.example .env
   ```

2. **Update `.env` with your configuration:**
   - Database credentials
   - Admin user credentials
   - Google OAuth credentials (optional)

3. **Run PostgreSQL:**
   ```bash
   docker run --name postgres -e POSTGRES_USER=vapor_username \
     -e POSTGRES_PASSWORD=vapor_password \
     -e POSTGRES_DB=vapor_database \
     -p 5432:5432 -d postgres
   ```

4. **Run migrations:**
   ```bash
   swift run Run migrate --yes
   ```

5. **Start the server:**
   ```bash
   swift run
   ```

Server will start at `http://localhost:8080`

## API Endpoints

### Core Authentication

- `POST /auth/register` - Register new user
- `POST /auth/login` - Login with email/password
- `GET /auth/me` - Get current user (requires auth)
- `POST /auth/logout` - Logout (requires auth)

### OAuth

- `GET /auth/google` - Redirect to Google OAuth
- `GET /auth/google/callback` - Google OAuth callback
- `GET /auth/providers` - List linked OAuth providers (requires auth)

### Public Registration Fields

- `GET /registration-fields` - Get active registration fields

### Admin (requires admin role)

- `GET /admin/registration-fields` - List all fields
- `POST /admin/registration-fields` - Create new field
- `GET /admin/registration-fields/:id` - Get specific field
- `PUT /admin/registration-fields/:id` - Update field
- `DELETE /admin/registration-fields/:id` - Delete field

## Testing

### Register a new user:
```bash
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "name": "John Doe"
  }'
```

### Login:
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

### Access protected endpoint:
```bash
curl -X GET http://localhost:8080/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Admin - Create registration field:
```bash
curl -X POST http://localhost:8080/admin/registration-fields \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "fieldName": "phone",
    "fieldLabel": "Phone Number",
    "fieldType": "text",
    "isRequired": false,
    "displayOrder": 1,
    "isActive": true
  }'
```

## Architecture

This example uses:
- **DefaultUser**: Pre-built user model with all features
- **DefaultUserToken**: Token authentication
- **DefaultOAuthProvider**: OAuth provider linking
- **Simple* Controllers**: Ready-to-use authentication controllers
- **Simple* Middleware**: Token and admin authentication

## Default Admin User

After running migrations, an admin user is created with credentials from `.env`:
- Email: From `ADMIN_EMAIL`
- Password: From `ADMIN_PASSWORD`

Use this account to access admin endpoints.
