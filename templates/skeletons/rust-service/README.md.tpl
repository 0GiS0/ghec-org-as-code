# $${parameters.name}

$${parameters.description}

## Overview

This is a Rust-based microservice for the Canary Trips system, specifically designed for El Hierro excursions. It uses the Axum web framework and SQLite for data persistence.

## Quick Start

### Prerequisites

- Rust 1.75 or later
- SQLite (included in dev container)
- Docker (for containerization)

### Development Setup

1. **Using Dev Container (Recommended)**:
   - Open the project in VS Code
   - Click "Reopen in Container" when prompted
   - The dev container includes Rust, SQLite, and all necessary tools

2. **Local Development**:
   ```bash
   # Install dependencies and build
   cargo build
   
   # Run the application
   cargo run
   ```

### Environment Variables

- `PORT`: Server port (default: 8080)
- `DATABASE_URL`: SQLite database path (default: sqlite:///workspace/db/$${parameters.name}.db)
- `RUST_LOG`: Logging level (debug, info, warn, error)

## API Endpoints

- `GET /health` - Health check
- `GET /api/v1/trips` - Get all trips
- `POST /api/v1/trips` - Create a new trip
- `GET /api/v1/trips/:id` - Get a specific trip
- `PUT /api/v1/trips/:id` - Update a trip
- `DELETE /api/v1/trips/:id` - Delete a trip

## Project Structure

```
$${parameters.name}/
├── src/                # Source code
├── migrations/         # Database migrations
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