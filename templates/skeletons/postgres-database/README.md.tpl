# $${parameters.name} Database

$${parameters.description}

## Overview

This is a PostgreSQL database template for the Canary Trips system. It provides a complete database setup with:

- Local development environment using Docker
- Azure PostgreSQL deployment with Terraform
- Sample schema for travel excursions
- Database migrations and scripts

## Quick Start

### Using Dev Container (Recommended)

1. Open the project in VS Code
2. Click "Reopen in Container" when prompted
3. The dev container will:
   - Start PostgreSQL in Docker
   - Create the database with sample data
   - Install all necessary tools

### Local Development

```bash
# Start PostgreSQL using Docker Compose
docker-compose up -d

# Wait for database to be ready
sleep 10

# Initialize the database
psql postgresql://postgres:password@localhost:5432/$${parameters.name} < scripts/init.sql
```

## Environment Variables

- `POSTGRES_DB`: Database name (default: $${parameters.name})
- `POSTGRES_USER`: Database user (default: postgres)
- `POSTGRES_PASSWORD`: Database password (default: password)
- `DATABASE_URL`: Full connection string

## Database Schema

The database includes:

### Tables

- **trips**: Travel excursions with pricing, duration, and availability
  - Supports UUID primary keys
  - Includes location indexing
  - Automatic timestamp updates

### Features

- UUID extension for unique identifiers
- Automatic timestamp updates via triggers
- Sample data for testing
- Proper indexing for performance

## Azure Deployment

Deploy to Azure PostgreSQL using Terraform:

```bash
cd terraform/azure
terraform init
terraform plan
terraform apply
```

This creates:
- Azure Database for PostgreSQL Flexible Server
- Database with proper configuration
- Security groups and access rules
- Backup and monitoring configuration

## Migrations

Database migrations are stored in the `migrations/` directory:

- `001_initial_schema.sql` - Creates the initial tables
- `002_add_indexes.sql` - Adds performance indexes
- `003_sample_data.sql` - Inserts sample data

## Contributing

1. Add new migrations with sequential numbering
2. Test all changes in the dev container
3. Update this README with schema changes
4. Test Azure deployment

## License

[Your License Here]