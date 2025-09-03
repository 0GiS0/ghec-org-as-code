### ${{values.name}} API Tests
### Base URL for development (HTTP)
@baseUrl = http://localhost:5000

### Base URL for development (HTTPS)
@baseUrlHttps = https://localhost:5001

### Health Check
GET {{baseUrl}}/health

### Root endpoint - Service information
GET {{baseUrl}}/

### Hello endpoint  
GET {{baseUrl}}/api/hello

### Status endpoint
GET {{baseUrl}}/api/status

### Get all excursions
GET {{baseUrl}}/api/excursions

### Get excursion by ID
GET {{baseUrl}}/api/excursions/1

### Create new excursion
POST {{baseUrl}}/api/excursions
Content-Type: application/json

{
  "name": "Test Adventure",
  "description": "A test excursion for API validation",
  "location": "Test Location",
  "price": 50.0,
  "duration": 3,
  "maxParticipants": 10
}

### Update excursion
PUT {{baseUrl}}/api/excursions/1
Content-Type: application/json

{
  "name": "Updated Test Adventure",
  "description": "An updated test excursion",
  "location": "Updated Location",
  "price": 75.0,
  "duration": 4,
  "maxParticipants": 12
}

### Delete excursion
DELETE {{baseUrl}}/api/excursions/1

### === HTTPS Tests ===

### Health Check (HTTPS)
GET {{baseUrlHttps}}/health

### API Documentation (Swagger)
GET {{baseUrl}}/docs