# AGENTS.md

## Project Description

${{values.description}}

This project is a FastAPI service that provides a modern REST API with automatic documentation, data validation, and ready-to-use development configuration.

## Setup Commands

- Install dependencies: `pip install -r requirements.txt -r requirements-dev.txt`
- Start development server: `uvicorn app.main:app --reload --host 0.0.0.0 --port 8000`
- Run tests: `pytest`
- Format code: `black . && isort .`
- Check code quality: `flake8 .`
- Run tests with coverage: `pytest --cov=app`

## Project Structure

- `app/main.py` - Main FastAPI application file
- `app/routers/` - API route definitions
- `app/models/` - Pydantic data models
- `tests/` - Unit and integration tests
- `requirements.txt` - Production dependencies
- `requirements-dev.txt` - Development dependencies
- `.env.example` - Example environment variables
- `.devcontainer/` - Development container configuration

## Code Style

- Use Python 3.11+ with type hints
- Follow PEP 8 with Black as formatter
- Use isort to organize imports
- Include docstrings for public functions and classes
- Keep files focused on single responsibility
- Use Pydantic for data validation

## Script Integrations

### Development Commands

- `uvicorn app.main:app --reload` - Development server with hot reload
- `pytest` - Run test suite
- `pytest --watch` - Tests in watch mode
- `black .` - Format code automatically
- `flake8 .` - Check code with linter

### External API Integrations

This service can integrate with external APIs using:
- `httpx` for asynchronous HTTP requests
- Environment variables for configuration
- Pydantic models for response validation

## Testing Instructions

### Unit Testing
- Run `pytest` to run all tests
- Use `pytest -v` for detailed output
- Tests are in the `tests/` directory
- Uses pytest as testing framework

### Integration Testing
- Use FastAPI's TestClient for API tests
- Mock external dependencies with pytest-mock
- Verify HTTP responses and schema validation

### Endpoint Testing
```bash
# Basic health check test
curl http://localhost:8000/health

# Automatic documentation test
curl http://localhost:8000/docs

# API endpoint test
curl http://localhost:8000/api/hello
```

## Development Configuration

1. Clone the repository
2. Create virtual environment: `python -m venv venv`
3. Activate environment: `source venv/bin/activate` (Linux/Mac) or `venv\Scripts\activate` (Windows)
4. Install dependencies: `pip install -r requirements.txt -r requirements-dev.txt`
5. Copy `.env.example` to `.env` and configure variables
6. Run `uvicorn app.main:app --reload` to start server
7. The application will be available at `http://localhost:8000`

### Required Environment Variables

```env
PORT=8000
HOST=0.0.0.0
ENVIRONMENT=development
```

## Security Considerations

- Use CORS middleware with restrictive configuration
- Validate all inputs with Pydantic
- Don't expose sensitive information in logs or responses
- Use environment variables for secrets
- Implement authentication and authorization when necessary
- Keep dependencies updated

## Troubleshooting

### Common Issues

**Port already in use error:**
- Change the `PORT` variable in `.env`
- Verify no other processes are using the port

**Dependency errors:**
- Recreate virtual environment
- Check Python version (requires 3.11+)
- Use `pip install --upgrade pip`

**Failing tests:**
- Verify development dependencies are installed
- Review pytest configuration in `pyproject.toml`

## PR Instructions

- Run `black .` and `isort .` before committing
- Check quality with `flake8 .`
- Ensure all tests pass with `pytest`
- Include tests for new functionality
- Update API documentation if necessary
- Follow semantic commit conventions

## State Management

This service is stateless by default. For state management:

- Use databases with SQLAlchemy or similar
- Implement cache with Redis
- Use FastAPI's dependency injection for resource management

## Templates and Workflows

### CI/CD Workflows

The project includes GitHub Actions workflows for:

- Running tests and linting on PRs
- Checking code coverage
- Building and deploying the application
- Security scanning

### Code Templates

- Follow router structure in `app/routers/`
- Use Pydantic models for request/response
- Implement middleware for common functionality
- Use dependency injection for configuration