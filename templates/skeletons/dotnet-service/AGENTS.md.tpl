# AGENTS.md

## Project Description

${{values.description}}

This project is a .NET service based on ASP.NET Core that provides a modern REST API with enterprise-ready configuration and clean architecture patterns.

## Setup Commands

- Restore dependencies: `dotnet restore`
- Build project: `dotnet build`
- Start development server: `dotnet run`
- Run tests: `dotnet test`
- Format code: `dotnet format`
- Publish for production: `dotnet publish -c Release`

## Project Structure

- `src/Program.cs` - Application entry point
- `src/Controllers/` - API controllers
- `src/Models/` - Data models and DTOs
- `src/Services/` - Business logic
- `tests/` - Unit and integration tests
- `src/appsettings.json` - Application configuration
- `.devcontainer/` - Development container configuration

## Code Style

- Use C# 11+ with nullable reference types
- Follow C# and .NET conventions
- Use PascalCase for public methods and properties
- Implement async/await for I/O operations
- Use dependency injection for services
- Include XML documentation for public APIs

## Script Integrations

### Available dotnet Commands

- `dotnet run` - Run application in development
- `dotnet watch run` - Development with hot reload
- `dotnet test --watch` - Tests in watch mode
- `dotnet format` - Format code automatically
- `dotnet add package` - Add NuGet dependencies

### Enterprise Integrations

This service can integrate with:
- Entity Framework Core for databases
- Azure services (Service Bus, Key Vault, etc.)
- Identity providers (Azure AD, Auth0)
- Monitoring (Application Insights, Serilog)

## Testing Instructions

### Unit Testing
- Run `dotnet test` for all tests
- Uses xUnit as testing framework
- Implement tests with MSTest or NUnit alternatively
- Tests are in `tests/` directory

### Integration Testing
- Use TestServer for API tests
- Mock external dependencies with Moq
- Verify HTTP responses and JSON serialization
- Test middleware and filters

### Endpoint Testing
```bash
# Basic health check test
curl http://localhost:5000/health

# API endpoint test
curl http://localhost:5000/api/values

# Swagger documentation test
curl http://localhost:5000/swagger
```

## Development Configuration

1. Install .NET 8 SDK or higher
2. Clone the repository
3. Run `dotnet restore` to restore dependencies
4. Configure `appsettings.Development.json` if necessary
5. Run `dotnet run` to start server
6. The application will be available at `https://localhost:5001`

### Appsettings Configuration

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "ConnectionStrings": {
    "DefaultConnection": "Data Source=app.db"
  }
}
```

## Security Considerations

- Use HTTPS in production
- Implement authentication and authorization
- Validate models with Data Annotations
- Use CORS with restrictive configuration
- Protect sensitive endpoints with [Authorize]
- Keep NuGet dependencies updated

## Troubleshooting

### Common Issues

**HTTPS certificate error:**
- Run `dotnet dev-certs https --trust`
- Verify certificate configuration

**Dependency errors:**
- Run `dotnet clean` and `dotnet restore`
- Check .NET SDK version

**Failing tests:**
- Verify TestHost is configured
- Review mocks and test setup

## PR Instructions

- Run `dotnet format` before committing
- Ensure `dotnet build` and `dotnet test` pass
- Include tests for new functionality
- Update XML documentation for APIs
- Verify Swagger/OpenAPI configuration

## State Management

### Dependency Injection
- Register services in `Program.cs`
- Use appropriate lifetimes (Singleton, Scoped, Transient)
- Implement interfaces for testability

### Configuration
- Use IOptions pattern for strongly-typed configuration
- Implement configuration validation
- Use different configurations per environment

## Templates and Workflows

### CI/CD Workflows

The project includes workflows for:

- Build and test on multiple .NET versions
- Code quality analysis with SonarQube
- Security scanning
- Deployment to Azure App Service

### Code Patterns

```csharp
// Controller pattern
[ApiController]
[Route("api/[controller]")]
public class ValuesController : ControllerBase
{
    private readonly IValueService _valueService;
    
    public ValuesController(IValueService valueService)
    {
        _valueService = valueService;
    }
    
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Value>>> GetValues()
    {
        var values = await _valueService.GetAllAsync();
        return Ok(values);
    }
}
```

### Custom Middleware

```csharp
public class ExceptionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<ExceptionMiddleware> _logger;

    public ExceptionMiddleware(RequestDelegate next, ILogger<ExceptionMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An unhandled exception occurred");
            await HandleExceptionAsync(context, ex);
        }
    }
}
```