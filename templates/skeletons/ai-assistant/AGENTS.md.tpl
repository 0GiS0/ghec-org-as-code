# AGENTS.md

## Descripción del proyecto

${{values.description}}

Este proyecto es un servicio de asistente de IA basado en FastAPI que proporciona capacidades de chat y interacción con modelos de inteligencia artificial.

## Comandos de configuración

- Instalar dependencias: `pip install -r requirements.txt`
- Iniciar servidor de desarrollo: `uvicorn src.main:app --reload --host 0.0.0.0 --port 8000`
- Ejecutar tests: `pytest`
- Formatear código: `black . && isort .`
- Verificar calidad de código: `flake8 .`

## Estructura del proyecto

- `src/main.py` - Archivo principal de la aplicación FastAPI
- `src/chat/` - Módulo de chat y lógica de IA
- `src/models/` - Modelos de datos para requests/responses
- `src/services/` - Servicios de integración con APIs de IA
- `requirements.txt` - Dependencias del proyecto
- `.env.example` - Variables de entorno de ejemplo
- `.devcontainer/` - Configuración de contenedor de desarrollo

## Estilo de código

- Usar Python 3.11+ con type hints
- Seguir PEP 8 con Black como formateador
- Usar isort para organizar imports
- Incluir docstrings para funciones de IA
- Mantener lógica de IA separada en módulos específicos
- Usar Pydantic para validación de modelos de chat

## Integraciones mediante Scripts

### Comandos de desarrollo

- `uvicorn src.main:app --reload` - Servidor con hot reload
- `pytest` - Ejecutar tests de IA y endpoints
- `black .` - Formatear código
- `python -m src.chat.test` - Test manual de chat

### Integraciones con servicios de IA

Este servicio puede integrarse con:
- OpenAI GPT models
- Azure OpenAI Service
- Anthropic Claude
- LangChain para workflows complejos
- Vector databases para RAG

## Instrucciones de testing

### Testing de IA
- Usar mocks para APIs de IA en tests unitarios
- Implementar tests de integración con rate limiting
- Verificar formatos de respuesta de chat
- Testear manejo de errores de API

### Testing de endpoints
```bash
# Test de health check
curl http://localhost:8000/health

# Test de chat endpoint
curl -X POST "http://localhost:8000/chat" \
     -H "Content-Type: application/json" \
     -d '{"message": "Hello, how can you help me?"}'

# Test de documentación
curl http://localhost:8000/docs
```

### Testing manual de IA
```python
# Script de test manual
from src.chat.service import ChatService

service = ChatService()
response = service.chat("Explain machine learning")
print(response)
```

## Configuración de desarrollo

1. Clonar el repositorio
2. Crear entorno virtual: `python -m venv venv`
3. Activar entorno: `source venv/bin/activate`
4. Instalar dependencias: `pip install -r requirements.txt`
5. Copiar `.env.example` a `.env` y configurar API keys
6. Ejecutar servidor: `uvicorn src.main:app --reload`
7. Acceder a `http://localhost:8000/docs` para documentación

### Variables de entorno requeridas

```env
OPENAI_API_KEY=sk-your-openai-key-here
AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/
AZURE_OPENAI_API_KEY=your-azure-key
MODEL_NAME=gpt-3.5-turbo
MAX_TOKENS=1000
TEMPERATURE=0.7
```

## Consideraciones de seguridad

- Proteger API keys con variables de entorno
- Implementar rate limiting para endpoints de IA
- Validar y sanitizar inputs de chat
- No loggear contenido sensible de conversaciones
- Usar timeouts para requests a APIs de IA
- Implementar autenticación para acceso a chat

## Solución de problemas

### Problemas comunes de IA

**Error de API key:**
- Verificar que OPENAI_API_KEY esté configurada
- Validar que la key tenga permisos correctos

**Rate limiting de OpenAI:**
- Implementar exponential backoff
- Usar rate limiting en el servicio

**Respuestas lentas:**
- Ajustar timeout de requests
- Usar modelos más rápidos para desarrollo
- Implementar streaming para respuestas largas

**Errores de contexto:**
- Verificar límites de tokens del modelo
- Implementar truncado de historial de chat

## Instrucciones de PR

- Ejecutar todos los tests incluyendo mocks de IA
- Verificar que no se commiteen API keys reales
- Incluir tests para nuevas funcionalidades de chat
- Documentar cambios en modelos o prompts
- Actualizar variables de entorno de ejemplo

## Gestión de estado

### Estado de conversaciones
- Implementar memoria de chat con Redis o database
- Usar session IDs para tracking de conversaciones
- Considerar TTL para limpiar conversaciones viejas

### Estado de modelos
- Cache de respuestas comunes
- Gestión de contexto de conversación
- Almacenamiento de preferencias de usuario

## Plantillas y workflows

### Workflows de CI/CD para IA

El proyecto incluye workflows específicos para:

- Tests con mocks de APIs de IA
- Validación de prompts y respuestas
- Deployment con secrets de API keys
- Monitoreo de costos de API

### Plantillas de prompts

- Mantener prompts en archivos separados
- Usar templates para prompts dinámicos
- Versionar cambios en prompts
- Implementar A/B testing para prompts

### Integración con LangChain

```python
# Ejemplo de integración
from langchain.llms import OpenAI
from langchain.chains import ConversationChain

llm = OpenAI(temperature=0.7)
conversation = ConversationChain(llm=llm)
```