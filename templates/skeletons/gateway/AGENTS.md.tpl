# AGENTS.md

## Project Description

${{values.description}}

This project is a Kong-based API Gateway that provides a centralized entry point for microservices, including authentication, rate limiting, and traffic routing.

## Setup Commands

- Start gateway: `docker-compose up -d`
- Verify configuration: `kong config parse`
- Reload configuration: `kong reload`
- View logs: `docker-compose logs -f kong`
- Stop gateway: `docker-compose down`

## Project Structure

- `docker-compose.yml` - Kong and Postgres container configuration
- `config/kong.yml` - Kong declarative configuration
- `README.md` - Project documentation
- `.devcontainer/` - Development container configuration
- `.github/workflows/` - CI/CD pipelines

## Code Style

- Use declarative YAML configuration for Kong
- Keep configuration versioned in git
- Document all services and routes
- Use descriptive names for services and routes
- Group configuration by domain/service
- Include comments for complex configuration

## Script Integrations

### Available Docker Commands

- `docker-compose up -d` - Start complete stack
- `docker-compose logs kong` - View gateway logs
- `docker-compose exec kong kong health` - Health check
- `docker-compose restart kong` - Restart Kong

### Service Integrations

This gateway can integrate:
- REST and GraphQL microservices
- Authentication services (JWT, OAuth2)
- Databases for rate limiting
- Monitoring and logging systems

## Testing Instructions

### Configuration Testing
```bash
# Validate Kong configuration
kong config parse config/kong.yml

# Connectivity test
curl http://localhost:8000/health

# Admin API test
curl http://localhost:8001/services
```

### Route Testing
```bash
# Basic routing test
curl -H "Host: api.example.com" http://localhost:8000/health

# Rate limiting test
for i in {1..10}; do curl http://localhost:8000/api/test; done

# CORS test
curl -H "Origin: http://localhost:3000" \
     -H "Access-Control-Request-Method: POST" \
     -X OPTIONS http://localhost:8000/api/data
```

### Plugin Testing
```bash
# JWT authentication test
curl -H "Authorization: Bearer <token>" http://localhost:8000/api/secure

# Header transformation test
curl -v http://localhost:8000/api/transform
```

## Development Configuration

1. Install Docker and Docker Compose
2. Clone the repository
3. Configure environment variables if necessary
4. Run `docker-compose up -d` to start Kong
5. Verify Kong is running: `curl http://localhost:8001`
6. The gateway will be available at `http://localhost:8000`

### Environment Variables

```env
KONG_DATABASE=postgres
KONG_PG_HOST=db
KONG_PG_DATABASE=kong
KONG_PG_USER=kong
KONG_PG_PASSWORD=kong
KONG_ADMIN_LISTEN=0.0.0.0:8001
```

## Security Considerations

- Protect Kong Admin API with authentication
- Use HTTPS in production with valid certificates
- Implement appropriate rate limiting
- Validate and sanitize request headers
- Use WAF for additional protection
- Monitor security logs

## Troubleshooting

### Common Issues

**Kong doesn't start:**
- Verify Postgres is running
- Check logs: `docker-compose logs kong`
- Validate configuration: `kong config parse`

**Routing error:**
- Verify services and routes configuration
- Check connectivity to backend services
- Review Host headers if necessary

**Rate limiting not working:**
- Verify plugin configuration
- Check storage backend (Redis/Postgres)
- Review Kong logs

## PR Instructions

- Validate configuration with `kong config parse`
- Test modified routes and plugins
- Document changes in README
- Include tests for new routes
- Verify existing routes aren't broken

## State Management

### Declarative Configuration
- All configuration in `config/kong.yml`
- Version control configuration
- Backup configuration before changes

### Databases
- Postgres for persistent storage
- Redis for rate limiting and caching
- Regular configuration backups

## Templates and Workflows

### CI/CD Workflows

The project includes workflows for:

- Kong configuration validation
- Connectivity and routing tests
- Automatic deployment to staging
- Rollback in case of errors

### Service Configuration

```yaml
# Service and route example
services:
  - name: my-service
    url: http://backend:8000
    routes:
      - name: my-route
        paths:
          - /api/v1
        methods:
          - GET
          - POST
        strip_path: false
```

### Plugin Configuration

```yaml
# Global plugins example
plugins:
  - name: cors
    config:
      origins:
        - "*"
      methods:
        - GET
        - POST
      headers:
        - Accept
        - Content-Type
        - Authorization

  - name: rate-limiting
    config:
      minute: 100
      hour: 1000
      policy: local
```

### Health Checks

```yaml
# Health check configuration
services:
  - name: health-service
    url: http://httpbin.org
    routes:
      - name: health-route
        paths:
          - /health
        methods:
          - GET
        strip_path: true
```