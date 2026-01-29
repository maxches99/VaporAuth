# MinimalAuthExample

Minimal example demonstrating **VaporAuthCore** only - basic email/password authentication.

## Features

- ✅ User registration with email and password
- ✅ User login and token-based authentication
- ✅ Protected endpoints with Bearer token
- ✅ User logout

This is the simplest possible setup - perfect for getting started or when you only need basic authentication.

## Setup

1. **Run PostgreSQL:**
   ```bash
   docker run --name postgres -e POSTGRES_USER=vapor_username \
     -e POSTGRES_PASSWORD=vapor_password \
     -e POSTGRES_DB=vapor_database \
     -p 5432:5432 -d postgres
   ```

2. **Run migrations:**
   ```bash
   swift run Run migrate --yes
   ```

3. **Start the server:**
   ```bash
   swift run
   ```

Server will start at `http://localhost:8080`

## API Endpoints

### Core Authentication

- `POST /auth/register` - Register new user
  ```json
  {
    "email": "user@example.com",
    "password": "password123",
    "name": "John Doe"
  }
  ```

- `POST /auth/login` - Login with email/password
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```

- `GET /auth/me` - Get current user (requires Bearer token)
  ```bash
  Authorization: Bearer YOUR_TOKEN
  ```

- `POST /auth/logout` - Logout (requires Bearer token)

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

Response:
```json
{
  "id": "uuid",
  "email": "user@example.com",
  "name": "John Doe",
  "token": "generated_token_here"
}
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

### Get current user:
```bash
curl -X GET http://localhost:8080/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Logout:
```bash
curl -X POST http://localhost:8080/auth/logout \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## What's Included

- **DefaultUser**: Pre-built user model
- **DefaultUserToken**: Token authentication
- **SimpleAuthController**: Ready-to-use authentication endpoints
- **SimpleTokenAuthenticator**: Bearer token middleware

## Next Steps

Want more features? Check out:
- **OAuthOnlyExample**: Add OAuth authentication (Google, Apple, etc.)
- **FullStackExample**: All features including admin roles and custom fields
