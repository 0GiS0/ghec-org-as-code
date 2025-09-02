# AGENTS.md

## Descripción del proyecto

${{values.description}}

Este proyecto es un API Gateway basado en Kong que proporciona un punto de entrada centralizado para microservicios, incluyendo autenticación, rate limiting, y routing de tráfico.

## Comandos de configuración

- Iniciar gateway: `docker-compose up -d`
- Verificar configuración: `kong config parse`
- Recargar configuración: `kong reload`
- Ver logs: `docker-compose logs -f kong`
- Detener gateway: `docker-compose down`

## Estructura del proyecto

- `docker-compose.yml` - Configuración de contenedores Kong y Postgres
- `config/kong.yml` - Configuración declarativa de Kong
- `README.md` - Documentación del proyecto
- `.devcontainer/` - Configuración de contenedor de desarrollo
- `.github/workflows/` - Pipelines de CI/CD

## Estilo de código

- Usar configuración declarativa YAML para Kong
- Mantener configuración versionada en git
- Documentar todos los services y routes
- Usar nombres descriptivos para services y routes
- Agrupar configuración por dominio/servicio
- Incluir comentarios en configuración compleja

## Integraciones mediante Scripts

### Comandos Docker disponibles

- `docker-compose up -d` - Iniciar stack completo
- `docker-compose logs kong` - Ver logs del gateway
- `docker-compose exec kong kong health` - Check de salud
- `docker-compose restart kong` - Reiniciar Kong

### Integraciones con servicios

Este gateway puede integrar:
- Microservicios REST y GraphQL
- Servicios de autenticación (JWT, OAuth2)
- Bases de datos para rate limiting
- Sistemas de monitoreo y logs

## Instrucciones de testing

### Testing de configuración
```bash
# Validar configuración de Kong
kong config parse config/kong.yml

# Test de conectividad
curl http://localhost:8000/health

# Test de admin API
curl http://localhost:8001/services
```

### Testing de rutas
```bash
# Test de routing básico
curl -H "Host: api.example.com" http://localhost:8000/health

# Test de rate limiting
for i in {1..10}; do curl http://localhost:8000/api/test; done

# Test de CORS
curl -H "Origin: http://localhost:3000" \
     -H "Access-Control-Request-Method: POST" \
     -X OPTIONS http://localhost:8000/api/data
```

### Testing de plugins
```bash
# Test de autenticación JWT
curl -H "Authorization: Bearer <token>" http://localhost:8000/api/secure

# Test de transformación de headers
curl -v http://localhost:8000/api/transform
```

## Configuración de desarrollo

1. Instalar Docker y Docker Compose
2. Clonar el repositorio
3. Configurar variables de entorno si es necesario
4. Ejecutar `docker-compose up -d` para iniciar Kong
5. Verificar que Kong esté funcionando: `curl http://localhost:8001`
6. El gateway estará disponible en `http://localhost:8000`

### Variables de entorno

```env
KONG_DATABASE=postgres
KONG_PG_HOST=db
KONG_PG_DATABASE=kong
KONG_PG_USER=kong
KONG_PG_PASSWORD=kong
KONG_ADMIN_LISTEN=0.0.0.0:8001
```

## Consideraciones de seguridad

- Proteger Kong Admin API con autenticación
- Usar HTTPS en producción con certificados válidos
- Implementar rate limiting apropiado
- Validar y sanitizar headers de requests
- Usar WAF para protección adicional
- Monitorear logs de seguridad

## Solución de problemas

### Problemas comunes

**Kong no inicia:**
- Verificar que Postgres esté corriendo
- Revisar logs: `docker-compose logs kong`
- Validar configuración: `kong config parse`

**Error de routing:**
- Verificar configuración de services y routes
- Comprobar conectividad a servicios backend
- Revisar headers Host si es necesario

**Rate limiting no funciona:**
- Verificar configuración de plugin
- Comprobar storage backend (Redis/Postgres)
- Revisar logs de Kong

## Instrucciones de PR

- Validar configuración con `kong config parse`
- Probar rutas y plugins modificados
- Documentar cambios en README
- Incluir tests para nuevas rutas
- Verificar que no se rompan rutas existentes

## Gestión de estado

### Configuración declarativa
- Toda la configuración en `config/kong.yml`
- Version control de configuración
- Backup de configuración antes de cambios

### Bases de datos
- Postgres para storage persistente
- Redis para rate limiting y caching
- Backup regular de configuración

## Plantillas y workflows

### Workflows de CI/CD

El proyecto incluye workflows para:

- Validación de configuración Kong
- Tests de conectividad y routing
- Deployment automático a staging
- Rollback en caso de errores

### Configuración de services

```yaml
# Ejemplo de service y route
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

### Configuración de plugins

```yaml
# Ejemplo de plugins globales
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

### Health checks

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