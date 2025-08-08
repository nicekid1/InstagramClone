# Instagram Clone Backend

This is the backend for an Instagram clone application built with a microservices architecture using NestJS.

## Architecture

The backend is built using a microservices architecture with the following services:

- **API Gateway**: Entry point for all client requests, handles authentication and routes requests to appropriate services
- **User Service**: Manages user accounts, profiles, and authentication
- **Post Service**: Handles creating, retrieving, updating, and deleting posts
- **Media Service**: Manages media uploads, storage, and retrieval
- **Social Service**: Handles social interactions like follows and blocks
- **Message Service**: Manages direct messages and conversations
- **Notification Service**: Handles notifications for various events
- **Story Service**: Manages user stories
- **Search Service**: Provides search functionality across the platform

## Getting Started

### Prerequisites

- Node.js (v14 or higher)
- npm or yarn
- Docker and Docker Compose (for containerized development)

### Installation

1. Clone the repository
2. Install dependencies:

```bash
npm install
```

### Development

To start all services in development mode:

```bash
npm run start:dev
```

To start a specific service:

```bash
npm run start:dev --service=user-service
```

### Docker

To run the application using Docker:

```bash
cd infrastructure/docker
docker-compose up
```

## Testing

To run tests:

```bash
npm test
```

To run integration tests:

```bash
npm run test:integration
```

## Documentation

For more detailed documentation, see the following:

- [Architecture Documentation](./docs/architecture.md)
- [API Documentation](./docs/api-docs.md)
- [Deployment Guide](./docs/deployment.md)
- [Development Guide](./docs/development.md)

## License

This project is licensed under the MIT License - see the LICENSE file for details.