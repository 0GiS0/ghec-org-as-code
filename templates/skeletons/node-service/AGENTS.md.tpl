# AGENTS.md

## Project Description

${{values.description}}

This project is a Node.js service based on Express.js that provides a REST API with basic endpoints and ready-to-use development configuration.

## Setup Commands

- Install dependencies: `npm install`
- Start development server: `npm run dev`
- Run tests: `npm test`
- Check code quality: `npm run lint`
- Build for production: `npm run build`
- Start production server: `npm start`

## Project Structure

- `src/index.js` - Main application file
- `src/routes/` - API route definitions
- `src/controllers/` - Application controllers
- `src/models/` - Data models
- `tests/` - Unit and integration tests
- `package.json` - Project configuration and dependencies
- `.env.example` - Example environment variables
- `.devcontainer/` - Development container configuration

## Code Style

- Use JavaScript ES6+ with modern syntax
- Follow configured ESLint rules
- Use descriptive names for variables and functions
- Include JSDoc comments for public functions
- Keep files small and focused on single responsibility

## Script Integrations

### Available npm Scripts

- `npm run dev` - Development server with hot reload
- `npm test` - Run test suite
- `npm run test:watch` - Tests in watch mode
- `npm run lint` - Check code with ESLint
- `npm run lint:fix` - Automatically fix lint issues

### External API Integrations

This service can integrate with external APIs. Configure appropriate environment variables in `.env`.

## Testing Instructions

### Unit Testing
- Run `npm test` to run all tests
- Use `npm run test:watch` during development
- Tests are in the `tests/` directory
- Uses Jest as testing framework

### Integration Testing
- Use Supertest for API tests
- Mock external dependencies when necessary
- Verify HTTP responses and data structure

### Endpoint Testing
```bash
# Basic health check test
curl http://localhost:3000/health

# API endpoint test
curl http://localhost:3000/api/hello
```

## Development Configuration

1. Clone the repository
2. Run `npm install` to install dependencies
3. Copy `.env.example` to `.env` and configure variables
4. Run `npm run dev` to start development server
5. The application will be available at `http://localhost:3000`

### Required Environment Variables

```env
PORT=3000
NODE_ENV=development
```

## Security Considerations

- Use Helmet for security headers
- Configure CORS appropriately
- Validate all user inputs
- Don't expose sensitive information in logs
- Use environment variables for secrets
- Keep dependencies updated

## Troubleshooting

### Common Issues

**Port already in use error:**
- Change the `PORT` variable in `.env`
- Verify no other processes are using the port

**Dependency errors:**
- Run `npm ci` for clean installation
- Check Node.js version (requires 18+)

**Failing tests:**
- Verify development dependencies are installed
- Review Jest configuration in `package.json`

## PR Instructions

- Run `npm run lint` before committing
- Ensure all tests pass with `npm test`
- Include tests for new functionality
- Update documentation if necessary
- Follow semantic commit conventions

## State Management

This service is stateless by default. For state management:

- Use databases for persistence
- Implement cache with Redis if necessary
- Consider architecture patterns for complex state

## Templates and Workflows

### CI/CD Workflows

The project includes GitHub Actions workflows for:

- Running tests on PRs
- Checking code quality
- Building and deploying the application

### Code Templates

- Follow controller structure in `src/controllers/`
- Use Express middleware for common functionality
- Implement consistent error handling