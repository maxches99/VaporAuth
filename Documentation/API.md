# VaporAuth API Documentation

Complete API reference for all VaporAuth endpoints.

## Table of Contents

1. [Authentication API](#authentication-api) (VaporAuthCore)
2. [OAuth API](#oauth-api) (VaporAuthOAuth)
3. [Admin API](#admin-api) (VaporAuthAdmin + VaporAuthFields)
4. [Public Fields API](#public-fields-api) (VaporAuthFields)
5. [Error Responses](#error-responses)

---

## Authentication API

Base path: `/auth`

### POST /auth/register

Register a new user with email and password.

**Request:**
```http
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securePassword123",
  "name": "John Doe"
}
```

**Response:** `201 Created`
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "name": "John Doe",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Errors:**
- `400 Bad Request` - Invalid email format or password too short
- `409 Conflict` - Email already exists

---

### POST /auth/login

Login with email and password.

**Request:**
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**Response:** `200 OK`
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "name": "John Doe",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Errors:**
- `400 Bad Request` - Missing email or password
- `401 Unauthorized` - Invalid credentials

---

### GET /auth/me

Get current authenticated user information.

**Authentication:** Required (Bearer token)

**Request:**
```http
GET /auth/me
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response:** `200 OK`
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "name": "John Doe"
}
```

**Errors:**
- `401 Unauthorized` - Missing or invalid token

---

### POST /auth/logout

Logout and invalidate current token.

**Authentication:** Required (Bearer token)

**Request:**
```http
POST /auth/logout
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response:** `204 No Content`

**Errors:**
- `401 Unauthorized` - Missing or invalid token

---

## OAuth API

Base path: `/auth`

### GET /auth/google

Redirect to Google OAuth consent screen.

**Request:**
```http
GET /auth/google
```

**Response:** `302 Found`
```
Location: https://accounts.google.com/o/oauth2/v2/auth?client_id=...&redirect_uri=...
```

**Notes:**
- User is redirected to Google
- After authentication, Google redirects to `/auth/google/callback`

---

### GET /auth/google/callback

Handle Google OAuth callback (automatic).

**Request:**
```http
GET /auth/google/callback?code=4/0AX4XfWh...&state=random_state
```

**Response:** `302 Found`
```
Location: /?token=TOKEN&source=google
```

**Success Flow:**
1. Exchange code for access token
2. Fetch user info from Google
3. Find or create user account
4. Generate app token
5. Redirect with token

**Error Redirect:**
```
Location: /?error=oauth_failed&reason=Failed+to+get+access+token
```

---

### GET /auth/providers

List OAuth providers linked to current user.

**Authentication:** Required (Bearer token)

**Request:**
```http
GET /auth/providers
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response:** `200 OK`
```json
[
  {
    "providerName": "google",
    "providerEmail": "user@gmail.com",
    "linkedAt": "2024-01-15T10:30:00Z"
  }
]
```

**Errors:**
- `401 Unauthorized` - Missing or invalid token

---

## Admin API

Base path: `/admin`

**Authentication:** All admin endpoints require:
1. Valid Bearer token
2. User with `admin` role

### GET /admin/registration-fields

List all registration fields (including inactive).

**Authentication:** Required (Admin role)

**Request:**
```http
GET /admin/registration-fields
Authorization: Bearer ADMIN_TOKEN
```

**Response:** `200 OK`
```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "fieldName": "phone",
    "fieldLabel": "Phone Number",
    "fieldType": "text",
    "isRequired": false,
    "displayOrder": 1,
    "isActive": true,
    "placeholder": "+1 (555) 123-4567",
    "helpText": "Enter your phone number",
    "validationPattern": "^\\+?[1-9]\\d{1,14}$",
    "options": null,
    "createdAt": "2024-01-15T10:00:00Z",
    "updatedAt": "2024-01-15T10:00:00Z"
  }
]
```

**Errors:**
- `401 Unauthorized` - Missing or invalid token
- `403 Forbidden` - User is not admin

---

### POST /admin/registration-fields

Create a new registration field.

**Authentication:** Required (Admin role)

**Request:**
```http
POST /admin/registration-fields
Authorization: Bearer ADMIN_TOKEN
Content-Type: application/json

{
  "fieldName": "company",
  "fieldLabel": "Company Name",
  "fieldType": "text",
  "isRequired": false,
  "displayOrder": 3,
  "isActive": true,
  "placeholder": "Acme Inc.",
  "helpText": "Your company name",
  "validationPattern": null,
  "options": null
}
```

**Field Types:**
- `text` - Single line text input
- `email` - Email input with validation
- `number` - Numeric input
- `select` - Dropdown selection (requires `options`)
- `checkbox` - Boolean checkbox
- `textarea` - Multi-line text input

**Response:** `201 Created`
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "fieldName": "company",
  "fieldLabel": "Company Name",
  "fieldType": "text",
  "isRequired": false,
  "displayOrder": 3,
  "isActive": true,
  "placeholder": "Acme Inc.",
  "helpText": "Your company name",
  "validationPattern": null,
  "options": null,
  "createdAt": "2024-01-15T11:00:00Z",
  "updatedAt": "2024-01-15T11:00:00Z"
}
```

**Errors:**
- `400 Bad Request` - Invalid field type or duplicate field name
- `401 Unauthorized` - Missing or invalid token
- `403 Forbidden` - User is not admin

---

### GET /admin/registration-fields/:id

Get specific registration field.

**Authentication:** Required (Admin role)

**Request:**
```http
GET /admin/registration-fields/550e8400-e29b-41d4-a716-446655440000
Authorization: Bearer ADMIN_TOKEN
```

**Response:** `200 OK`
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "fieldName": "phone",
  "fieldLabel": "Phone Number",
  "fieldType": "text",
  ...
}
```

**Errors:**
- `404 Not Found` - Field doesn't exist
- `401 Unauthorized` - Missing or invalid token
- `403 Forbidden` - User is not admin

---

### PUT /admin/registration-fields/:id

Update existing registration field.

**Authentication:** Required (Admin role)

**Request:**
```http
PUT /admin/registration-fields/550e8400-e29b-41d4-a716-446655440000
Authorization: Bearer ADMIN_TOKEN
Content-Type: application/json

{
  "fieldLabel": "Mobile Phone",
  "isRequired": true,
  "isActive": true
}
```

**Notes:**
- All fields are optional
- Only provided fields will be updated
- `fieldName` cannot be changed

**Response:** `200 OK`
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "fieldName": "phone",
  "fieldLabel": "Mobile Phone",
  "fieldType": "text",
  "isRequired": true,
  "isActive": true,
  ...
}
```

**Errors:**
- `400 Bad Request` - Invalid field type
- `404 Not Found` - Field doesn't exist
- `401 Unauthorized` - Missing or invalid token
- `403 Forbidden` - User is not admin

---

### DELETE /admin/registration-fields/:id

Delete registration field.

**Authentication:** Required (Admin role)

**Request:**
```http
DELETE /admin/registration-fields/550e8400-e29b-41d4-a716-446655440000
Authorization: Bearer ADMIN_TOKEN
```

**Response:** `204 No Content`

**Errors:**
- `404 Not Found` - Field doesn't exist
- `401 Unauthorized` - Missing or invalid token
- `403 Forbidden` - User is not admin

---

## Public Fields API

Base path: `/registration-fields`

### GET /registration-fields

Get all active registration fields (public endpoint).

**Authentication:** Not required

**Request:**
```http
GET /registration-fields
```

**Response:** `200 OK`
```json
[
  {
    "fieldName": "phone",
    "fieldLabel": "Phone Number",
    "fieldType": "text",
    "isRequired": false,
    "displayOrder": 1,
    "placeholder": "+1 (555) 123-4567",
    "helpText": "Enter your phone number",
    "validationPattern": "^\\+?[1-9]\\d{1,14}$",
    "options": null
  },
  {
    "fieldName": "country",
    "fieldLabel": "Country",
    "fieldType": "select",
    "isRequired": true,
    "displayOrder": 2,
    "placeholder": null,
    "helpText": "Select your country",
    "validationPattern": null,
    "options": ["USA", "Canada", "UK", "Other"]
  }
]
```

**Notes:**
- Only returns `isActive: true` fields
- Sorted by `displayOrder`
- Does not include admin-only fields (id, createdAt, updatedAt, isActive)

---

## Error Responses

All error responses follow this format:

```json
{
  "error": true,
  "reason": "Human-readable error message"
}
```

### HTTP Status Codes

| Code | Meaning | Common Causes |
|------|---------|---------------|
| `400` | Bad Request | Invalid input, validation failed |
| `401` | Unauthorized | Missing or invalid token |
| `403` | Forbidden | Insufficient permissions (not admin) |
| `404` | Not Found | Resource doesn't exist |
| `409` | Conflict | Duplicate resource (e.g., email exists) |
| `500` | Internal Server Error | Server-side error |

### Common Error Examples

#### Invalid Email
```http
HTTP/1.1 400 Bad Request
{
  "error": true,
  "reason": "Invalid email format"
}
```

#### Unauthorized
```http
HTTP/1.1 401 Unauthorized
{
  "error": true,
  "reason": "Authentication required"
}
```

#### Forbidden (Not Admin)
```http
HTTP/1.1 403 Forbidden
{
  "error": true,
  "reason": "Admin access required"
}
```

#### Resource Not Found
```http
HTTP/1.1 404 Not Found
{
  "error": true,
  "reason": "Registration field not found"
}
```

#### Duplicate Resource
```http
HTTP/1.1 409 Conflict
{
  "error": true,
  "reason": "Email already exists"
}
```

---

## Rate Limiting

Currently no rate limiting is implemented. Consider adding rate limiting middleware for production:

```swift
app.middleware.use(RateLimitMiddleware())
```

---

## Versioning

Current API version: **v1**

Future versions will be prefixed: `/v2/auth/...`

---

## Authentication Headers

All protected endpoints require Bearer token authentication:

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

Token expiration: **30 days** (configurable)

---

## Content Type

All requests and responses use JSON:

```http
Content-Type: application/json
```

---

## CORS

Configure CORS in production:

```swift
let corsConfiguration = CORSMiddleware.Configuration(
    allowedOrigin: .all,
    allowedMethods: [.GET, .POST, .PUT, .DELETE],
    allowedHeaders: [.accept, .authorization, .contentType, .origin]
)
app.middleware.use(CORSMiddleware(configuration: corsConfiguration))
```

---

## Testing

Example test suite using curl:

```bash
# Register
TOKEN=$(curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"pass123","name":"Test"}' \
  | jq -r '.token')

# Get current user
curl -X GET http://localhost:8080/auth/me \
  -H "Authorization: Bearer $TOKEN"

# Get public fields
curl -X GET http://localhost:8080/registration-fields

# Logout
curl -X POST http://localhost:8080/auth/logout \
  -H "Authorization: Bearer $TOKEN"
```

---

## Support

- 📖 [Getting Started Guide](./GettingStarted.md)
- 🔄 [Migration Guide](./MigrationGuide.md)
- 💬 [GitHub Discussions](https://github.com/yourusername/VaporAuth/discussions)
