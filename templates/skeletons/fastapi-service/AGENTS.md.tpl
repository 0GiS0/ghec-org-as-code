# AGENTS.md

## Descripción del proyecto

${{values.description}}

Este proyecto es un servicio FastAPI que proporciona una API REST moderna con documentación automática, validación de datos y configuración de desarrollo lista para usar.

## Comandos de configuración

- Instalar dependencias: `pip install -r requirements.txt -r requirements-dev.txt`
- Iniciar servidor de desarrollo: `uvicorn app.main:app --reload --host 0.0.0.0 --port 8000`
- Ejecutar tests: `pytest`
- Formatear código: `black . && isort .`
- Verificar calidad de código: `flake8 .`
- Ejecutar tests con cobertura: `pytest --cov=app`

## Estructura del proyecto

- `app/main.py` - Archivo principal de la aplicación FastAPI
- `app/routers/` - Definiciones de rutas de la API
- `app/models/` - Modelos de datos Pydantic
- `tests/` - Tests unitarios y de integración
- `requirements.txt` - Dependencias de producción
- `requirements-dev.txt` - Dependencias de desarrollo
- `.env.example` - Variables de entorno de ejemplo
- `.devcontainer/` - Configuración de contenedor de desarrollo

## Estilo de código

- Usar Python 3.11+ con type hints
- Seguir PEP 8 con Black como formateador
- Usar isort para organizar imports
- Incluir docstrings para funciones y clases públicas
- Mantener archivos enfocados en una responsabilidad
- Usar Pydantic para validación de datos

## Integraciones mediante Scripts

### Comandos de desarrollo

- `uvicorn app.main:app --reload` - Servidor de desarrollo con hot reload
- `pytest` - Ejecutar suite de tests
- `pytest --watch` - Tests en modo watch
- `black .` - Formatear código automáticamente
- `flake8 .` - Verificar código con linter

### Integraciones con API externa

Este servicio puede integrarse con APIs externas usando:
- `httpx` para requests HTTP asíncronos
- Variables de entorno para configuración
- Modelos Pydantic para validación de respuestas

## Instrucciones de testing

### Testing unitario
- Ejecutar `pytest` para correr todos los tests
- Usar `pytest -v` para output detallado
- Los tests están en el directorio `tests/`
- Usar pytest como framework de testing

### Testing de integración
- Usar TestClient de FastAPI para tests de API
- Mockear dependencias externas con pytest-mock
- Verificar respuestas HTTP y validación de esquemas

### Testing de endpoints
```bash
# Test básico de health check
curl http://localhost:8000/health

# Test de documentación automática
curl http://localhost:8000/docs

# Test de endpoint de API
curl http://localhost:8000/api/hello
```

## Configuración de desarrollo

1. Clonar el repositorio
2. Crear entorno virtual: `python -m venv venv`
3. Activar entorno: `source venv/bin/activate` (Linux/Mac) o `venv\Scripts\activate` (Windows)
4. Instalar dependencias: `pip install -r requirements.txt -r requirements-dev.txt`
5. Copiar `.env.example` a `.env` y configurar variables
6. Ejecutar `uvicorn app.main:app --reload` para iniciar servidor
7. La aplicación estará disponible en `http://localhost:8000`

### Variables de entorno requeridas

```env
PORT=8000
HOST=0.0.0.0
ENVIRONMENT=development
```

## Consideraciones de seguridad

- Usar CORS middleware con configuración restrictiva
- Validar todas las entradas con Pydantic
- No exponer información sensible en logs o respuestas
- Usar variables de entorno para secretos
- Implementar autenticación y autorización cuando sea necesario
- Mantener dependencias actualizadas

## Solución de problemas

### Problemas comunes

**Error de puerto ocupado:**
- Cambiar la variable `PORT` en `.env`
- Verificar que no hay otros procesos usando el puerto

**Errores de dependencias:**
- Recrear entorno virtual
- Verificar versión de Python (requiere 3.11+)
- Usar `pip install --upgrade pip`

**Tests fallando:**
- Verificar que las dependencias de desarrollo estén instaladas
- Revisar configuración de pytest en `pyproject.toml`

## Instrucciones de PR

- Ejecutar `black .` y `isort .` antes de hacer commit
- Verificar calidad con `flake8 .`
- Asegurar que todos los tests pasen con `pytest`
- Incluir tests para nuevas funcionalidades
- Actualizar documentación API si es necesario
- Seguir convenciones de commit semántico

## Gestión de estado

Este servicio es stateless por defecto. Para gestión de estado:

- Usar bases de datos con SQLAlchemy o similar
- Implementar cache con Redis
- Usar dependency injection de FastAPI para gestión de recursos

## Plantillas y workflows

### Workflows de CI/CD

El proyecto incluye workflows de GitHub Actions para:

- Ejecutar tests y linting en PRs
- Verificar cobertura de código
- Construir y deployar la aplicación
- Escaneo de seguridad

### Plantillas de código

- Seguir estructura de routers en `app/routers/`
- Usar modelos Pydantic para request/response
- Implementar middleware para funcionalidad común
- Usar dependency injection para configuración