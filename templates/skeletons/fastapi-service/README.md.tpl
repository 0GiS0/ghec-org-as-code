# $${parameters.name}

${{parameters.description}}

## 🚀 Quick Start

### Prerequisites

- Python 3.11 or higher
- pip

### Development

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt -r requirements-dev.txt
   ```

2. **Start development server:**
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

3. **Run tests:**
   ```bash
   pytest
   ```

4. **Format code:**
   ```bash
   black .
   isort .
   ```

5. **Lint code:**
   ```bash
   flake8 .
   ```

### API Documentation

- Interactive API docs: http://localhost:8000/docs
- Alternative docs: http://localhost:8000/redoc
- OpenAPI schema: http://localhost:8000/openapi.json

### API Endpoints

- `GET /` - Root endpoint with service information
- `GET /health` - Health check endpoint
- `GET /api/hello` - Hello world endpoint
- `GET /api/status` - Service status endpoint

### Environment Variables

Create a `.env` file in the root directory:

```env
PORT=8000
HOST=0.0.0.0
ENVIRONMENT=development
```

### Docker Development

This project includes a dev container configuration. Open in VS Code and use "Dev Containers: Reopen in Container".

### Production Deployment

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

## 📝 Architecture

This is a FastAPI service with:

- FastAPI web framework
- Pydantic for data validation
- CORS middleware
- Environment variable configuration
- Health check endpoints
- Automatic OpenAPI documentation
- Pytest for testing

## 🧪 Testing

Run the test suite:

```bash
pytest
```

Run with coverage:

```bash
pytest --cov=app
```

## 📦 Dependencies

- **fastapi**: Modern web framework
- **uvicorn**: ASGI server
- **pydantic**: Data validation
- **python-dotenv**: Environment variable management

## 🛠️ Development Dependencies

- **pytest**: Testing framework
- **httpx**: HTTP client for testing
- **black**: Code formatter
- **flake8**: Code linter
- **isort**: Import organizer