# Node.js Service Template

[![Template CI/CD](https://github.com/${github_organization}/${repository_name}/actions/workflows/ci-template.yml/badge.svg)](https://github.com/${github_organization}/${repository_name}/actions/workflows/ci-template.yml)

This template allows you to create a new Node.js microservice with TypeScript, Express, and development best practices.

## What does this template include?

### Technologies and frameworks
- **Node.js** with **TypeScript** for static typing
- **Express.js** as web framework
- **ESLint** and **Prettier** for code quality
- **Jest** for testing
- **Supertest** for API testing
- **Swagger/OpenAPI** for API documentation

### Project structure
- `src/` - Application source code
  - `controllers/` - API controllers
  - `models/` - Data models
  - `routes/` - Route definitions
  - `middleware/` - Custom middlewares
- `tests/` - Automated tests
- `.devcontainer/` - Configuration for container development
- `.github/workflows/` - CI/CD pipelines

### Included features
- **REST API** with CRUD endpoints for memes
- **Health checks** for monitoring
- **Structured logging** with Winston
- **Data validation** with Joi
- **Centralized error handling**
- **Rate limiting** for protection
- **CORS** configured
- **Automatic documentation** with Swagger

### DevOps and CI/CD
- **GitHub Actions** for CI/CD
- **Docker** and **DevContainer** for development
- **Dependabot** for automatic updates
- **CodeQL** for security analysis
- **MkDocs** for technical documentation

## Usage

1. Use this template from Backstage
2. Complete the form with:
   - Project name (in kebab-case)
   - Service description
   - System it belongs to
   - Service tier (1-3 or experimental)
   - Responsible team

3. The template will create:
   - Repository with complete structure
   - Branch protection configuration
   - Configured CI/CD pipelines
   - Initial documentation

## Generated structure

```
my-service/
├── src/
│   ├── controllers/
│   │   └── MemeController.js
│   ├── models/
│   │   └── Meme.js
│   ├── routes/
│   │   └── memes.js
│   └── index.js
├── tests/
│   └── api.test.js
├── .devcontainer/
│   └── devcontainer.json
├── .github/
│   └── workflows/
│       └── ci.yml
├── docs/
│   ├── index.md
│   └── api.md
├── package.json
├── tsconfig.json
├── .eslintrc.js
├── .prettierrc
├── Dockerfile
├── docker-compose.yml
└── README.md
```

## Included best practices

- **12 Factor App** principles
- **RESTful API** design
- **Error handling** patterns
- **Security headers** and middlewares
- **Environment configuration**
- **Graceful shutdown**
- **Health checks** for Kubernetes
- **Observability** (logs, metrics)

## Support

- **Documentation**: Check the generated documentation in `docs/`
- **Issues**: Report problems in the template repository
- **Slack**: #platform-team channel for support

### Static Badges Regeneration

The `Generate Badges` workflow updates SVGs in `badges/` when:

- Push to `main`
- Issue is created/edited/closed/reopened/deleted
- `Template CI/CD` workflow finishes
- Manually executed (workflow_dispatch)

If you add new badges:
1. Edit `.github/workflows/generate_badges.yml` and generate a new SVG file (e.g., `coverage.svg`).
2. Add the reference in this README: `![Coverage](./badges/coverage.svg)`.
3. Trigger the workflow manually to generate it.

Existing badges:
- `ci-status.svg`: Latest CI workflow conclusion (success, failure, running...)
- `issues-open.svg`: Current number of open issues (colors by thresholds)

> Tip: Avoid linking directly to Shields.io in private repos; external requests may expose metadata or fail after authentication.
