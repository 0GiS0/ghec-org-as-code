# AGENTS.md

## Descripción del proyecto

${{values.description}}

Este proyecto es un servicio Node.js basado en Express.js que proporciona una API REST con endpoints básicos y configuración de desarrollo lista para usar.

## Comandos de configuración

- Instalar dependencias: `npm install`
- Iniciar servidor de desarrollo: `npm run dev`
- Ejecutar tests: `npm test`
- Verificar calidad de código: `npm run lint`
- Construir para producción: `npm run build`
- Iniciar servidor de producción: `npm start`

## Estructura del proyecto

- `src/index.js` - Archivo principal de la aplicación
- `src/routes/` - Definiciones de rutas de la API
- `src/controllers/` - Controladores de la aplicación
- `src/models/` - Modelos de datos
- `tests/` - Tests unitarios y de integración
- `package.json` - Configuración del proyecto y dependencias
- `.env.example` - Variables de entorno de ejemplo
- `.devcontainer/` - Configuración de contenedor de desarrollo

## Estilo de código

- Usar JavaScript ES6+ con sintaxis moderna
- Seguir las reglas de ESLint configuradas
- Usar nombres descriptivos para variables y funciones
- Incluir comentarios JSDoc para funciones públicas
- Mantener archivos pequeños y enfocados en una responsabilidad

## Integraciones mediante Scripts

### Scripts npm disponibles

- `npm run dev` - Servidor de desarrollo con hot reload
- `npm test` - Ejecutar suite de tests
- `npm run test:watch` - Tests en modo watch
- `npm run lint` - Verificar código con ESLint
- `npm run lint:fix` - Corregir automáticamente problemas de lint

### Integraciones con API externa

Este servicio puede integrarse con APIs externas. Configurar variables de entorno apropiadas en `.env`.

## Instrucciones de testing

### Testing unitario
- Ejecutar `npm test` para correr todos los tests
- Usar `npm run test:watch` durante desarrollo
- Los tests están en el directorio `tests/`
- Usar Jest como framework de testing

### Testing de integración
- Usar Supertest para tests de API
- Mockear dependencias externas cuando sea necesario
- Verificar respuestas HTTP y estructura de datos

### Testing de endpoints
```bash
# Test básico de health check
curl http://localhost:3000/health

# Test de endpoint de API
curl http://localhost:3000/api/hello
```

## Configuración de desarrollo

1. Clonar el repositorio
2. Ejecutar `npm install` para instalar dependencias
3. Copiar `.env.example` a `.env` y configurar variables
4. Ejecutar `npm run dev` para iniciar servidor de desarrollo
5. La aplicación estará disponible en `http://localhost:3000`

### Variables de entorno requeridas

```env
PORT=3000
NODE_ENV=development
```

## Consideraciones de seguridad

- Usar Helmet para headers de seguridad
- Configurar CORS apropiadamente
- Validar todas las entradas de usuario
- No exponer información sensible en logs
- Usar variables de entorno para secretos
- Mantener dependencias actualizadas

## Solución de problemas

### Problemas comunes

**Error de puerto ocupado:**
- Cambiar la variable `PORT` en `.env`
- Verificar que no hay otros procesos usando el puerto

**Errores de dependencias:**
- Ejecutar `npm ci` para instalación limpia
- Verificar versión de Node.js (requiere 18+)

**Tests fallando:**
- Verificar que las dependencias de desarrollo estén instaladas
- Revisar configuración de Jest en `package.json`

## Instrucciones de PR

- Ejecutar `npm run lint` antes de hacer commit
- Asegurar que todos los tests pasen con `npm test`
- Incluir tests para nuevas funcionalidades
- Actualizar documentación si es necesario
- Seguir convenciones de commit semántico

## Gestión de estado

Este servicio es stateless por defecto. Para gestión de estado:

- Usar bases de datos para persistencia
- Implementar cache con Redis si es necesario
- Considerar patrones de arquitectura para estado complejo

## Plantillas y workflows

### Workflows de CI/CD

El proyecto incluye workflows de GitHub Actions para:

- Ejecutar tests en PRs
- Verificar calidad de código
- Construir y deployar la aplicación

### Plantillas de código

- Seguir estructura de controladores en `src/controllers/`
- Usar middleware de Express para funcionalidad común
- Implementar manejo de errores consistente