### ${{values.name}} AI Assistant API Tests
### Base URL for development
@baseUrl = http://localhost:8000

### Health Check
GET {{baseUrl}}/health

### Root endpoint - Service information
GET {{baseUrl}}/

### Get all excursions
GET {{baseUrl}}/excursions

### Search excursions by criteria
GET {{baseUrl}}/excursions/search?location=Mountain&maxPrice=100&difficulty=easy

### Chat with AI Assistant
POST {{baseUrl}}/chat
Content-Type: application/json

{
  "message": "I want a mountain hiking adventure for beginners",
  "context": ""
}

### Get personalized recommendations
POST {{baseUrl}}/recommend
Content-Type: application/json

{
  "budget": 100,
  "difficulty": "easy",
  "interests": ["hiking", "nature"],
  "season": "summer"
}

### Chat - General greeting
POST {{baseUrl}}/chat
Content-Type: application/json

{
  "message": "Hello, what can you help me with?",
  "context": ""
}

### Chat - Specific request
POST {{baseUrl}}/chat
Content-Type: application/json

{
  "message": "Find me a food tour under $50",
  "context": ""
}

### API Documentation
GET {{baseUrl}}/docs