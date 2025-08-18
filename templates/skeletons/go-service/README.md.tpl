# $${parameters.name}

$${parameters.description}

## Overview

This is a Go-based microservice for the Canary Trips system, specifically designed for Fuerteventura excursions. It uses the Gin web framework and MongoDB for data persistence.

## Quick Start

### Prerequisites

- Go 1.21 or later
- MongoDB (included in dev container)
- Docker (for containerization)

### Development Setup

1. **Using Dev Container (Recommended)**:
   - Open the project in VS Code
   - Click "Reopen in Container" when prompted
   - The dev container includes Go, MongoDB, and all necessary tools

2. **Local Development**:
   ```bash
   # Install dependencies
   go mod download
   
   # Start MongoDB (if not using dev container)
   docker run -d -p 27017:27017 --name mongodb mongo:7.0
   
   # Run the application
   go run cmd/server/main.go
   ```

### Environment Variables

- `PORT`: Server port (default: 8080)
- `MONGODB_URI`: MongoDB connection string (default: mongodb://localhost:27017/$${parameters.name})
- `GO_ENV`: Environment (development, production)

## API Endpoints

- `GET /api/v1/health` - Health check
- `GET /api/v1/trips` - Get all trips
- `POST /api/v1/trips` - Create a new trip
- `GET /api/v1/trips/:id` - Get a specific trip
- `PUT /api/v1/trips/:id` - Update a trip
- `DELETE /api/v1/trips/:id` - Delete a trip

## Project Structure

```
$${parameters.name}/
├── cmd/server/          # Application entry point
├── internal/handlers/   # HTTP handlers
├── pkg/models/         # Data models
├── tests/              # Test files
├── terraform/azure/    # Azure infrastructure as code
└── .devcontainer/      # Dev container configuration
```

## Deployment

This service includes Terraform configurations for deployment to Azure:

```bash
cd terraform/azure
terraform init
terraform plan
terraform apply
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

[Your License Here]