# $${parameters.name}

${{parameters.description}}

## 🚀 Quick Start

### Prerequisites

- .NET 8.0 SDK or higher

### Development

1. **Restore dependencies:**
   ```bash
   dotnet restore src/$${parameters.name}.csproj
   ```

2. **Build the project:**
   ```bash
   dotnet build src/$${parameters.name}.csproj
   ```

3. **Start development server:**
   ```bash
   dotnet run --project src/$${parameters.name}.csproj
   ```

4. **Run tests:**
   ```bash
   dotnet test
   ```

### API Documentation

- Swagger UI: https://localhost:5001/docs
- API: https://localhost:5001

### API Endpoints

- `GET /` - Root endpoint with service information
- `GET /health` - Health check endpoint
- `GET /api/hello` - Hello world endpoint
- `GET /api/status` - Service status endpoint

### Docker Development

This project includes a dev container configuration. Open in VS Code and use "Dev Containers: Reopen in Container".

### Production Deployment

```bash
dotnet publish src/$${parameters.name}.csproj -c Release -o ./publish
dotnet ./publish/$${parameters.name}.dll
```

## 📝 Architecture

This is an ASP.NET Core Web API with:

- ASP.NET Core 8.0
- Swagger/OpenAPI documentation
- Health checks
- CORS support
- Structured logging
- Minimal APIs and Controllers

## 🧪 Testing

Run the test suite:

```bash
dotnet test
```

Run with coverage:

```bash
dotnet test --collect:"XPlat Code Coverage"
```

## 📦 Dependencies

- **Microsoft.AspNetCore.OpenApi**: OpenAPI support
- **Swashbuckle.AspNetCore**: Swagger documentation
- **Microsoft.Extensions.Diagnostics.HealthChecks**: Health checks