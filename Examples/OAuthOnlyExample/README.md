# OAuthOnlyExample

Example demonstrating **VaporAuthCore** + **VaporAuthOAuth** - email/password authentication plus OAuth integration.

## Features

- ✅ User registration with email and password
- ✅ User login with email/password
- ✅ Google OAuth authentication
- ✅ Account linking (link OAuth to existing email account)
- ✅ OAuth-only users (users without passwords)
- ✅ List linked OAuth providers

## Setup

1. **Get Google OAuth credentials:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing
   - Enable Google+ API
   - Create OAuth 2.0 credentials
   - Add authorized redirect URI: `http://localhost:8080/auth/google/callback`

2. **Copy environment variables:**
   ```bash
   cp .env.example .env
   ```

3. **Update `.env` with your Google OAuth credentials:**
   ```
   GOOGLE_CLIENT_ID=your_actual_client_id
   GOOGLE_CLIENT_SECRET=your_actual_client_secret
   GOOGLE_CALLBACK_URL=http://localhost:8080/auth/google/callback
   ```

4. **Run PostgreSQL:**
   ```bash
   docker run --name postgres -e POSTGRES_USER=vapor_username \
     -e POSTGRES_PASSWORD=vapor_password \
     -e POSTGRES_DB=vapor_database \
     -p 5432:5432 -d postgres
   ```

5. **Run migrations:**
   ```bash
   swift run Run migrate --yes
   ```

6. **Start the server:**
   ```bash
   swift run
   ```

Server will start at `http://localhost:8080`

## API Endpoints

### Core Authentication

- `POST /auth/register` - Register new user with email/password
- `POST /auth/login` - Login with email/password
- `GET /auth/me` - Get current user (requires auth)
- `POST /auth/logout` - Logout (requires auth)

### OAuth Authentication

- `GET /auth/google` - Redirect to Google OAuth consent screen
- `GET /auth/google/callback` - Google OAuth callback (automatic)
- `GET /auth/providers` - List linked OAuth providers (requires auth)

## Usage Flows

### Flow 1: Traditional Registration
1. User registers with email/password via `POST /auth/register`
2. User can login with `POST /auth/login`

### Flow 2: OAuth-Only Registration
1. User clicks "Sign in with Google"
2. Browser redirects to `GET /auth/google`
3. User authenticates with Google
4. Google redirects back to `/auth/google/callback`
5. System creates user without password
6. User receives token and can access protected endpoints

### Flow 3: Account Linking
1. User already registered with email/password
2. User clicks "Link Google Account"
3. Browser redirects to `GET /auth/google`
4. User authenticates with Google
5. System links Google account to existing user
6. User can now login with either method

## Testing OAuth Flow

1. **Start the authentication:**
   ```bash
   # Open in browser
   open http://localhost:8080/auth/google
   ```

2. **Complete Google authentication** in browser

3. **You'll be redirected back** with a token in the URL:
   ```
   http://localhost:8080/?token=YOUR_TOKEN&source=google
   ```

4. **Use the token** to access protected endpoints:
   ```bash
   curl -X GET http://localhost:8080/auth/me \
     -H "Authorization: Bearer YOUR_TOKEN"
   ```

5. **Check linked providers:**
   ```bash
   curl -X GET http://localhost:8080/auth/providers \
     -H "Authorization: Bearer YOUR_TOKEN"
   ```

   Response:
   ```json
   [
     {
       "providerName": "google",
       "providerEmail": "user@gmail.com",
       "linkedAt": "2024-01-15T10:30:00Z"
     }
   ]
   ```

## Architecture

This example demonstrates:
- **DefaultUser**: User model with optional password (allows OAuth-only users)
- **DefaultOAuthProvider**: Stores OAuth provider information
- **SimpleOAuthService**: Handles account creation and linking
- **GoogleOAuthProvider**: Implements Google OAuth 2.0 flow
- **Account Linking**: Automatically links OAuth to existing email accounts

## Account Linking Logic

When a user authenticates with Google:

1. **Check if OAuth provider exists** → Return existing user
2. **Check if email exists** → Link OAuth to existing user
3. **Create new user** → OAuth-only user without password

This allows users to:
- Register with email/password, then link Google later
- Register with Google, then add password later
- Use multiple OAuth providers with one account

## Next Steps

Want more features? Check out:
- **FullStackExample**: All features including admin roles and custom fields
- **MinimalAuthExample**: Simpler example with just email/password
