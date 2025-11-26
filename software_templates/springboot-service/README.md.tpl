# Spring Boot Service Template

[![Template CI/CD](https://github.com/${github_organization}/${repository_name}/actions/workflows/ci-template.yml/badge.svg)](https://github.com/${github_organization}/${repository_name}/actions/workflows/ci-template.yml)

This template allows you to create a new Spring Boot microservice with Java 21, Maven, and development best practices.

## What does this template include?

### Technologies and frameworks
- **Java 21** (LTS) with latest language features
- **Spring Boot 3.4** as the application framework
- **Spring Web** for REST API development
- **Spring Data JPA** for data persistence
- **Spring Actuator** for production-ready features
- **Maven** as build tool
- **JUnit 5** and **Mockito** for testing
- **Lombok** to reduce boilerplate code
- **MapStruct** for DTO mapping
- **OpenAPI/Swagger** for API documentation

### Project structure
- `src/main/java/` - Application source code
  - `controller/` - REST controllers
  - `service/` - Business logic
  - `repository/` - Data access layer
  - `model/` - Domain entities
  - `dto/` - Data Transfer Objects
  - `config/` - Configuration classes
  - `exception/` - Custom exceptions
- `src/main/resources/` - Configuration files
- `src/test/java/` - Automated tests
- `.devcontainer/` - Configuration for container development
- `.github/workflows/` - CI/CD pipelines

### Included features
- **REST API** with CRUD endpoints example
- **Health checks** via Spring Actuator
- **Structured logging** with SLF4J/Logback
- **Data validation** with Bean Validation
- **Global exception handling** with @ControllerAdvice
- **API documentation** with SpringDoc OpenAPI
- **Database migrations** with Flyway
- **Connection pooling** with HikariCP

### DevOps and CI/CD
- **GitHub Actions** for CI/CD
- **Docker** and **DevContainer** for development
- **Dependabot** for automatic updates
- **CodeQL** for security analysis
- **MkDocs** for technical documentation
- **Testcontainers** for integration testing

## Usage

1. Use this template from Backstage
2. Complete the form with:
   - Project name (in kebab-case)
   - Service description
   - System it belongs to
   - Service tier (1-3 or experimental)
   - Responsible team
   - Java version (17 or 21)
   - Spring Boot version

3. The template will create:
   - Repository with complete structure
   - Branch protection configuration
   - Configured CI/CD pipelines
   - Initial documentation

## Generated structure

```
my-service/
├── src/
│   ├── main/
│   │   ├── java/com/example/demo/
│   │   │   ├── Application.java
│   │   │   ├── controller/
│   │   │   │   └── ItemController.java
│   │   │   ├── service/
│   │   │   │   └── ItemService.java
│   │   │   ├── repository/
│   │   │   │   └── ItemRepository.java
│   │   │   ├── model/
│   │   │   │   └── Item.java
│   │   │   ├── dto/
│   │   │   │   └── ItemDTO.java
│   │   │   ├── config/
│   │   │   │   └── OpenApiConfig.java
│   │   │   └── exception/
│   │   │       └── GlobalExceptionHandler.java
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       └── db/migration/
│   └── test/
│       └── java/com/example/demo/
│           └── controller/
│               └── ItemControllerTest.java
├── .devcontainer/
│   └── devcontainer.json
├── .github/
│   ├── dependabot.yml
│   └── workflows/
│       └── ci.yml
├── docs/
│   ├── index.md
│   └── api/
├── pom.xml
├── Dockerfile
├── docker-compose.yml
├── api.http
├── catalog-info.yaml
└── README.md
```

## Included best practices

- **12 Factor App** principles
- **RESTful API** design patterns
- **Layered architecture** (Controller → Service → Repository)
- **DTO pattern** for API contracts
- **Dependency Injection** with Spring
- **Configuration externalization**
- **Graceful shutdown** support
- **Health checks** for Kubernetes
- **Observability** (metrics, health, info endpoints)
- **Security headers** and CORS configuration

## API Endpoints

The generated service includes example endpoints:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/items` | List all items |
| GET | `/api/items/{id}` | Get item by ID |
| POST | `/api/items` | Create new item |
| PUT | `/api/items/{id}` | Update item |
| DELETE | `/api/items/{id}` | Delete item |
| GET | `/actuator/health` | Health check |
| GET | `/swagger-ui.html` | API documentation |

## Development

### Prerequisites
- Java 21 or higher
- Maven 3.9 or higher
- Docker (optional, for containers)

### Running locally

```bash
# Build the project
mvn clean package

# Run the application
mvn spring-boot:run

# Run tests
mvn test

# Run with specific profile
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

### Using DevContainer

Open the project in VS Code with Dev Containers extension for a fully configured development environment.

## Documentation

- [Spring Boot Reference](https://docs.spring.io/spring-boot/reference/)
- [Spring Web MVC](https://docs.spring.io/spring-framework/reference/web/webmvc.html)
- [Spring Data JPA](https://docs.spring.io/spring-data/jpa/reference/)
