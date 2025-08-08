# Development Guide

## Overview

This document provides guidelines and instructions for developers working on the Instagram Clone backend. It covers setup procedures, coding standards, testing practices, and workflow recommendations.

## Getting Started

### Prerequisites

- Node.js (v16 or later)
- npm (v7 or later)
- Docker and Docker Compose
- Git
- PostgreSQL (if running databases locally)
- Redis (if running caches locally)

### Setting Up the Development Environment

1. Clone the repository:

```bash
$ git clone https://github.com/your-organization/instagram-clone.git
$ cd instagram-clone/backend
```

2. Install dependencies:

```bash
$ npm install
```

3. Set up environment variables:

```bash
$ cp .env.example .env
# Edit .env with your local configuration
```

4. Build the common library:

```bash
$ npm run build:libs
```

5. Start the development environment with Docker:

```bash
$ docker-compose -f infrastructure/docker/docker-compose.dev.yml up -d postgres redis
```

6. Run database migrations:

```bash
$ npm run migration:run
```

7. Start the development server:

```bash
# Start all services
$ npm run start:dev

# Start a specific service
$ npm run start:dev:api-gateway
$ npm run start:dev:user-service
# etc.
```

## Project Structure

```
backend/
├── api-gateway/           # API Gateway service
│   ├── src/
│   │   ├── modules/       # Feature modules
│   │   ├── config/        # Configuration
│   │   └── main.ts        # Entry point
│   └── test/              # Tests
├── services/              # Microservices
│   ├── user-service/
│   ├── post-service/
│   ├── media-service/
│   └── ...
├── libs/                  # Shared libraries
│   └── common/            # Common utilities and interfaces
├── infrastructure/        # Infrastructure configuration
│   ├── docker/
│   ├── k8s/
│   ├── monitoring/
│   └── terraform/
├── docs/                  # Documentation
├── scripts/               # Utility scripts
└── tests/                 # Integration tests
```

## Development Workflow

### Feature Development Process

1. **Create a feature branch**:

```bash
$ git checkout -b feature/feature-name
```

2. **Implement the feature**:
   - Follow the coding standards
   - Write unit tests
   - Ensure all tests pass

3. **Create a pull request**:
   - Provide a clear description of the changes
   - Reference any related issues
   - Ensure CI checks pass

4. **Code review**:
   - Address review comments
   - Make necessary changes

5. **Merge**:
   - Squash and merge to main branch
   - Delete the feature branch

### Bug Fix Process

1. **Create a bug fix branch**:

```bash
$ git checkout -b fix/bug-description
```

2. **Implement the fix**:
   - Write a test that reproduces the bug
   - Fix the bug
   - Ensure all tests pass

3. **Follow the same PR process as for features**

## Coding Standards

### TypeScript Guidelines

- Use TypeScript for all new code
- Enable strict mode in tsconfig.json
- Use interfaces for object shapes
- Use enums for fixed sets of values
- Use type guards when necessary

### Naming Conventions

- **Files**: Use kebab-case for filenames (e.g., `user-service.ts`)
- **Classes**: Use PascalCase for class names (e.g., `UserService`)
- **Interfaces**: Use PascalCase with a descriptive name (e.g., `UserDto`)
- **Methods/Functions**: Use camelCase (e.g., `getUserById`)
- **Variables**: Use camelCase (e.g., `userCount`)
- **Constants**: Use UPPER_SNAKE_CASE (e.g., `MAX_UPLOAD_SIZE`)

### Code Organization

- Follow the Single Responsibility Principle
- Keep files under 300 lines when possible
- Group related functionality in modules
- Use dependency injection for services

### Error Handling

- Use custom exception classes
- Provide meaningful error messages
- Log errors with appropriate context
- Return consistent error responses from APIs

## API Design Guidelines

### RESTful Principles

- Use appropriate HTTP methods (GET, POST, PUT, DELETE)
- Use plural nouns for resource endpoints (e.g., `/users`, `/posts`)
- Use nested routes for related resources (e.g., `/users/:userId/posts`)
- Use query parameters for filtering, sorting, and pagination

### Request/Response Format

- Use JSON for request and response bodies
- Use camelCase for JSON property names
- Include a root data property for successful responses
- Follow a consistent error response format

### Versioning

- Include version in the URL path (e.g., `/v1/users`)
- Maintain backward compatibility within a version

### Documentation

- Document all APIs using OpenAPI/Swagger
- Include example requests and responses
- Document error responses

## Database Guidelines

### Schema Design

- Use meaningful table and column names
- Define appropriate indexes
- Use foreign keys for relationships
- Include created_at and updated_at timestamps

### Query Optimization

- Write efficient queries
- Use query builders or ORM features appropriately
- Avoid N+1 query problems

### Migrations

- Create migrations for all schema changes
- Make migrations reversible when possible
- Test migrations before applying to production

## Testing Guidelines

### Unit Testing

- Write unit tests for all business logic
- Mock external dependencies
- Aim for high test coverage

```bash
# Run unit tests
$ npm run test

# Run tests with coverage
$ npm run test:cov
```

### Integration Testing

- Test API endpoints
- Test service interactions
- Use test databases

```bash
# Run integration tests
$ npm run test:e2e
```

### Test Organization

- Keep test files close to the code they test
- Use descriptive test names
- Follow the Arrange-Act-Assert pattern

## Debugging

### Local Debugging

- Use the built-in Node.js debugger
- Configure VS Code launch configurations
- Use logging for runtime information

### Logging

- Use appropriate log levels (debug, info, warn, error)
- Include contextual information in logs
- Avoid logging sensitive data

```typescript
// Example logging
import { Logger } from '@app/common';

const logger = new Logger('UserService');
logger.debug('Processing user request', { userId });
```

## Performance Considerations

### Optimization Techniques

- Use caching for frequently accessed data
- Implement pagination for large data sets
- Use database indexes effectively
- Optimize API response sizes

### Monitoring

- Monitor service performance
- Track database query performance
- Set up alerts for performance degradation

## Security Best Practices

### Authentication and Authorization

- Use JWT for authentication
- Implement role-based access control
- Validate user permissions for each action

### Data Protection

- Hash passwords using bcrypt
- Encrypt sensitive data
- Implement rate limiting
- Validate and sanitize all user inputs

### Security Headers

- Set appropriate security headers
- Implement CORS correctly
- Use HTTPS for all communications

## Working with Microservices

### Service Communication

- Use HTTP/REST for synchronous communication
- Use message queues for asynchronous communication
- Implement circuit breakers for resilience

### Service Discovery

- Configure service discovery in development
- Use environment variables for service URLs

### Data Consistency

- Implement eventual consistency patterns
- Use transactions when necessary
- Consider using the Saga pattern for distributed transactions

## Dependency Management

### Adding Dependencies

- Evaluate packages before adding them
- Consider package size, maintenance status, and security
- Document why a dependency was added

### Updating Dependencies

- Regularly update dependencies
- Test thoroughly after updates
- Keep track of breaking changes

```bash
# Check for outdated packages
$ npm outdated

# Update packages
$ npm update
```

## Documentation

### Code Documentation

- Document public APIs with JSDoc comments
- Explain complex logic with inline comments
- Keep documentation up to date with code changes

### Project Documentation

- Maintain README files
- Document architecture decisions
- Provide setup and development instructions

## Continuous Integration

### CI Pipeline

- Run linting
- Run unit and integration tests
- Check code coverage
- Build Docker images

### Pre-commit Hooks

- Run linting
- Run unit tests
- Format code

## Troubleshooting Common Issues

### Development Environment

- **Issue**: Services can't connect to each other
  - **Solution**: Check service URLs and network configuration

- **Issue**: Database connection errors
  - **Solution**: Verify database credentials and connection string

- **Issue**: Changes not reflecting
  - **Solution**: Ensure the service is restarted or watching for changes

### Build Issues

- **Issue**: TypeScript compilation errors
  - **Solution**: Check for type errors and fix them

- **Issue**: Missing dependencies
  - **Solution**: Run `npm install` to install dependencies

## Conclusion

Following these development guidelines will help maintain code quality, consistency, and developer productivity across the Instagram Clone backend project. If you have questions or suggestions for improving these guidelines, please discuss them with the team.