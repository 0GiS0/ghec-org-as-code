# AGENTS.md

## Project Description

${{values.description}}

This project is a modern frontend application built with Astro, optimized for performance and content-focused with server-side rendering capabilities.

## Setup Commands

- Install dependencies: `npm install`
- Start development server: `npm run dev`
- Build for production: `npm run build`
- Production preview: `npm run preview`
- Check types: `npm run check`
- Format code: `npm run format`

## Project Structure

- `src/pages/` - Application pages (file-based routing)
- `src/components/` - Reusable components
- `src/layouts/` - Page layouts
- `src/styles/` - Global styles and CSS
- `src/content/` - Application content (markdown, etc.)
- `public/` - Static files
- `astro.config.mjs` - Astro configuration

## Code Style

- Use TypeScript for type safety
- Follow Astro conventions for components
- Use CSS modules or styled-components as preferred
- Keep components small and reusable
- Follow semantic web principles
- Optimize for performance and SEO

## Script Integrations

### Available npm Scripts

- `npm run dev` - Development server with hot reload
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run check` - Check TypeScript types
- `npm run format` - Format code with Prettier

### Frontend Integrations

This project can integrate with:
- REST and GraphQL APIs
- Headless CMS (Strapi, Contentful)
- Authentication services
- Analytics and monitoring

## Testing Instructions

### Component Testing
- Use Vitest for unit tests
- Implement component tests with Testing Library
- Verify accessibility with jest-axe
- Test rendering and behavior

### Integration Testing
```bash
# Local development test
npm run dev
# Navigate to http://localhost:4321

# Production build test
npm run build
npm run preview
```

### Performance Testing
- Use Lighthouse for performance audits
- Verify Core Web Vitals metrics
- Test on different devices and connections

## Development Configuration

1. Clone the repository
2. Install Node.js 18+ and npm/yarn
3. Run `npm install` to install dependencies
4. Configure environment variables if necessary
5. Run `npm run dev` to start development server
6. The application will be available at `http://localhost:4321`

### Optional Environment Variables

```env
PUBLIC_API_URL=https://api.example.com
PUBLIC_SITE_URL=https://mysite.com
```

## Security Considerations

- Validate form data on client and server
- Use HTTPS in production
- Implement appropriate CSP headers
- Validate user inputs
- Protect sensitive routes
- Use environment variables for public secrets

## Troubleshooting

### Common Issues

**Build error:**
- Verify Astro component syntax
- Review imports and exports
- Validate configuration in astro.config.mjs

**TypeScript type issues:**
- Run `npm run check` for diagnostics
- Verify configuration in tsconfig.json
- Install types for dependencies

**Performance issues:**
- Use Astro DevTools for debugging
- Verify component lazy loading
- Optimize images and assets

## PR Instructions

- Run `npm run check` to verify types
- Ensure `npm run build` works correctly
- Include tests for new components
- Verify accessibility and SEO
- Update component documentation

## State Management

### Client State
- Use Astro stores for global state
- Implement local state in components when necessary
- Consider Zustand or similar for complex state

### Server State
- Use Astro endpoints for APIs
- Implement SSG/SSR based on needs
- Appropriate caching for static content

## Templates and Workflows

### CI/CD Workflows

The project includes workflows for:

- Automatic build and test on PRs
- Deploy to static hosting (Netlify, Vercel)
- Performance audits
- Accessibility tests

### Component Structure

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

### Framework Integration

```typescript
// React components (optional)
import React from 'react';

// Vue components (optional)
import Vue from 'vue';

// Svelte components (optional)
import Svelte from 'svelte';
```

### SEO and Meta Tags

```astro
---
import Layout from '../layouts/Layout.astro';
---

<Layout title="My Page" description="Page description">
  <main>
    <!-- Page content -->
  </main>
</Layout>
```