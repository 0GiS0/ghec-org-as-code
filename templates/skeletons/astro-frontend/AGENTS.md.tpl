# AGENTS.md

## Descripción del proyecto

${{values.description}}

Este proyecto es una aplicación frontend moderna construida con Astro, optimizada para rendimiento y enfocada en contenido con capacidades de server-side rendering.

## Comandos de configuración

- Instalar dependencias: `npm install`
- Iniciar servidor de desarrollo: `npm run dev`
- Construir para producción: `npm run build`
- Vista previa de producción: `npm run preview`
- Verificar tipos: `npm run check`
- Formatear código: `npm run format`

## Estructura del proyecto

- `src/pages/` - Páginas de la aplicación (routing basado en archivos)
- `src/components/` - Componentes reutilizables
- `src/layouts/` - Layouts de página
- `src/styles/` - Estilos globales y CSS
- `src/content/` - Contenido de la aplicación (markdown, etc.)
- `public/` - Archivos estáticos
- `astro.config.mjs` - Configuración de Astro

## Estilo de código

- Usar TypeScript para type safety
- Seguir convenciones de Astro para componentes
- Usar CSS modules o styled-components según preferencia
- Mantener componentes pequeños y reutilizables
- Seguir principios de web semántico
- Optimizar para performance y SEO

## Integraciones mediante Scripts

### Scripts npm disponibles

- `npm run dev` - Servidor de desarrollo con hot reload
- `npm run build` - Construir para producción
- `npm run preview` - Vista previa de build de producción
- `npm run check` - Verificar tipos de TypeScript
- `npm run format` - Formatear código con Prettier

### Integraciones de frontend

Este proyecto puede integrarse con:
- APIs REST y GraphQL
- Headless CMS (Strapi, Contentful)
- Servicios de autenticación
- Analytics y monitoreo

## Instrucciones de testing

### Testing de componentes
- Usar Vitest para tests unitarios
- Implementar tests de componentes con Testing Library
- Verificar accesibilidad con jest-axe
- Testear rendering y comportamiento

### Testing de integración
```bash
# Test de desarrollo local
npm run dev
# Navegar a http://localhost:4321

# Test de build de producción
npm run build
npm run preview
```

### Testing de performance
- Usar Lighthouse para auditorías de performance
- Verificar métricas Core Web Vitals
- Testear en diferentes dispositivos y conexiones

## Configuración de desarrollo

1. Clonar el repositorio
2. Instalar Node.js 18+ y npm/yarn
3. Ejecutar `npm install` para instalar dependencias
4. Configurar variables de entorno si es necesario
5. Ejecutar `npm run dev` para iniciar servidor de desarrollo
6. La aplicación estará disponible en `http://localhost:4321`

### Variables de entorno opcionales

```env
PUBLIC_API_URL=https://api.example.com
PUBLIC_SITE_URL=https://mysite.com
```

## Consideraciones de seguridad

- Validar datos de formularios en client y server
- Usar HTTPS en producción
- Implementar CSP headers apropiados
- Validar inputs de usuario
- Proteger rutas sensibles
- Usar variables de entorno para secrets públicos

## Solución de problemas

### Problemas comunes

**Error de build:**
- Verificar sintaxis de componentes Astro
- Revisar imports y exports
- Validar configuración en astro.config.mjs

**Problemas de tipos TypeScript:**
- Ejecutar `npm run check` para diagnóstico
- Verificar configuración en tsconfig.json
- Instalar types para dependencias

**Performance issues:**
- Usar Astro DevTools para debugging
- Verificar lazy loading de componentes
- Optimizar imágenes y assets

## Instrucciones de PR

- Ejecutar `npm run check` para verificar tipos
- Asegurar que `npm run build` funcione correctamente
- Incluir tests para nuevos componentes
- Verificar accesibilidad y SEO
- Actualizar documentación de componentes

## Gestión de estado

### Estado de cliente
- Usar stores de Astro para estado global
- Implementar estado local en componentes cuando sea necesario
- Considerar Zustand o similar para estado complejo

### Estado del servidor
- Usar Astro endpoints para APIs
- Implementar SSG/SSR según necesidades
- Cache apropiado para contenido estático

## Plantillas y workflows

### Workflows de CI/CD

El proyecto incluye workflows para:

- Build y test automático en PRs
- Deploy a hosting estático (Netlify, Vercel)
- Auditorías de performance
- Tests de accesibilidad

### Estructura de componentes

```astro
---
// Component Script (JavaScript/TypeScript)
export interface Props {
  title: string;
  description?: string;
}

const { title, description } = Astro.props;
---

<!-- Component Template (HTML + expressions) -->
<div class="component">
  <h2>{title}</h2>
  {description && <p>{description}</p>}
</div>

<style>
  /* Component Styles (Scoped CSS) */
  .component {
    padding: 1rem;
  }
</style>
```

### Integración con frameworks

```typescript
// React components (opcional)
import React from 'react';

// Vue components (opcional)
import Vue from 'vue';

// Svelte components (opcional)
import Svelte from 'svelte';
```

### SEO y meta tags

```astro
---
import Layout from '../layouts/Layout.astro';
---

<Layout title="Mi Página" description="Descripción de la página">
  <main>
    <!-- Contenido de la página -->
  </main>
</Layout>
```