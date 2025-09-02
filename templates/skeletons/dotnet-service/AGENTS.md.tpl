# AGENTS.md

## Descripción del proyecto

${{values.description}}

Este proyecto es un servicio .NET basado en ASP.NET Core que proporciona una API REST moderna con configuración enterprise-ready y patrones de arquitectura limpia.

## Comandos de configuración

- Restaurar dependencias: `dotnet restore`
- Construir proyecto: `dotnet build`
- Iniciar servidor de desarrollo: `dotnet run`
- Ejecutar tests: `dotnet test`
- Formatear código: `dotnet format`
- Publicar para producción: `dotnet publish -c Release`

## Estructura del proyecto

- `src/Program.cs` - Punto de entrada de la aplicación
- `src/Controllers/` - Controladores de API
- `src/Models/` - Modelos de datos y DTOs
- `src/Services/` - Lógica de negocio
- `tests/` - Tests unitarios y de integración
- `src/appsettings.json` - Configuración de la aplicación
- `.devcontainer/` - Configuración de contenedor de desarrollo

## Estilo de código

- Usar C# 11+ con nullable reference types
- Seguir convenciones de C# y .NET
- Usar PascalCase para métodos y propiedades públicas
- Implementar async/await para operaciones I/O
- Usar dependency injection para servicios
- Incluir XML documentation para APIs públicas

## Integraciones mediante Scripts

### Comandos dotnet disponibles

- `dotnet run` - Ejecutar aplicación en desarrollo
- `dotnet watch run` - Desarrollo con hot reload
- `dotnet test --watch` - Tests en modo watch
- `dotnet format` - Formatear código automáticamente
- `dotnet add package` - Agregar dependencias NuGet

### Integraciones enterprise

Este servicio puede integrarse con:
- Entity Framework Core para bases de datos
- Azure services (Service Bus, Key Vault, etc.)
- Identity providers (Azure AD, Auth0)
- Monitoring (Application Insights, Serilog)

## Instrucciones de testing

### Testing unitario
- Ejecutar `dotnet test` para todos los tests
- Usar xUnit como framework de testing
- Implementar tests con MSTest o NUnit alternativamente
- Tests están en directorio `tests/`

### Testing de integración
- Usar TestServer para tests de API
- Mockear dependencias externas con Moq
- Verificar respuestas HTTP y serialización JSON
- Testear middleware y filters

### Testing de endpoints
```bash
# Test básico de health check
curl http://localhost:5000/health

# Test de endpoint de API
curl http://localhost:5000/api/values

# Test de Swagger documentation
curl http://localhost:5000/swagger
```

## Configuración de desarrollo

1. Instalar .NET 8 SDK o superior
2. Clonar el repositorio
3. Ejecutar `dotnet restore` para restaurar dependencias
4. Configurar `appsettings.Development.json` si es necesario
5. Ejecutar `dotnet run` para iniciar servidor
6. La aplicación estará disponible en `https://localhost:5001`

### Configuración de appsettings

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

## Consideraciones de seguridad

- Usar HTTPS en producción
- Implementar authentication y authorization
- Validar modelos con Data Annotations
- Usar CORS con configuración restrictiva
- Proteger endpoints sensibles con [Authorize]
- Mantener dependencias NuGet actualizadas

## Solución de problemas

### Problemas comunes

**Error de certificado HTTPS:**
- Ejecutar `dotnet dev-certs https --trust`
- Verificar configuración de certificados

**Errores de dependencias:**
- Ejecutar `dotnet clean` y `dotnet restore`
- Verificar versión de .NET SDK

**Tests fallando:**
- Verificar que TestHost esté configurado
- Revisar mocks y setup de tests

## Instrucciones de PR

- Ejecutar `dotnet format` antes de hacer commit
- Asegurar que `dotnet build` y `dotnet test` pasen
- Incluir tests para nuevas funcionalidades
- Actualizar XML documentation para APIs
- Verificar configuración de Swagger/OpenAPI

## Gestión de estado

### Dependency Injection
- Registrar servicios en `Program.cs`
- Usar lifetimes apropiados (Singleton, Scoped, Transient)
- Implementar interfaces para testabilidad

### Configuración
- Usar IOptions pattern para configuración fuerte
- Implementar validation de configuración
- Usar diferentes configuraciones por entorno

## Plantillas y workflows

### Workflows de CI/CD

El proyecto incluye workflows para:

- Build y test en múltiples versiones de .NET
- Code quality analysis con SonarQube
- Security scanning
- Deployment a Azure App Service

### Patterns de código

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

### Middleware personalizado

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