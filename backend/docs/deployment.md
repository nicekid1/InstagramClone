# Deployment Guide

## Overview

This document provides instructions for deploying the Instagram Clone backend services to various environments. The application is designed to be deployed using Docker containers and can be orchestrated with Docker Compose for development/testing or Kubernetes for production environments.

## Prerequisites

- Docker and Docker Compose installed
- Kubernetes cluster (for production deployment)
- kubectl CLI configured to access your cluster
- Helm (optional, for Kubernetes deployments)
- Access to container registry (Docker Hub, AWS ECR, Google Container Registry, etc.)

## Environment Configuration

Before deployment, ensure all environment variables are properly configured:

1. Copy the `.env.example` file to create a new `.env` file for each environment (development, staging, production)
2. Update the environment variables with appropriate values for each environment
3. Ensure database connection strings, API keys, and secrets are properly set

## Docker Deployment

### Building Docker Images

To build all service images:

```bash
# From the root of the backend directory
$ docker-compose -f infrastructure/docker/docker-compose.yml build
```

To build a specific service:

```bash
$ docker-compose -f infrastructure/docker/docker-compose.yml build <service-name>
```

### Local Development with Docker Compose

```bash
# Start all services
$ docker-compose -f infrastructure/docker/docker-compose.dev.yml up

# Start specific services
$ docker-compose -f infrastructure/docker/docker-compose.dev.yml up api-gateway postgres redis

# Run in detached mode
$ docker-compose -f infrastructure/docker/docker-compose.dev.yml up -d
```

### Production Deployment with Docker Compose

```bash
$ docker-compose -f infrastructure/docker/docker-compose.prod.yml up -d
```

## Kubernetes Deployment

### Preparing for Kubernetes Deployment

1. Build and push Docker images to your container registry:

```bash
# Tag images
$ docker tag instagram-clone/api-gateway:latest your-registry/instagram-clone/api-gateway:latest
$ docker tag instagram-clone/user-service:latest your-registry/instagram-clone/user-service:latest
# ... tag other services

# Push images
$ docker push your-registry/instagram-clone/api-gateway:latest
$ docker push your-registry/instagram-clone/user-service:latest
# ... push other services
```

2. Update Kubernetes manifests with the correct image references

### Deploying with kubectl

```bash
# Apply ConfigMaps and Secrets first
$ kubectl apply -f infrastructure/k8s/configmap.yaml
$ kubectl apply -f infrastructure/k8s/secret.yaml

# Deploy services
$ kubectl apply -f infrastructure/k8s/deployment.yaml
$ kubectl apply -f infrastructure/k8s/service.yaml

# Deploy ingress
$ kubectl apply -f infrastructure/k8s/ingress.yaml
```

### Deploying with Helm (Optional)

If you have created Helm charts for your application:

```bash
$ helm install instagram-clone ./infrastructure/helm/instagram-clone
```

## Scaling Services

### Scaling with Docker Compose

```bash
$ docker-compose -f infrastructure/docker/docker-compose.prod.yml up -d --scale user-service=3 --scale post-service=2
```

### Scaling with Kubernetes

```bash
$ kubectl scale deployment user-service --replicas=3
$ kubectl scale deployment post-service --replicas=2
```

## Database Migrations

Before deploying new versions, ensure database migrations are applied:

```bash
# For development
$ docker-compose -f infrastructure/docker/docker-compose.dev.yml run --rm api-gateway npm run migration:run

# For production
$ kubectl exec -it $(kubectl get pods -l app=api-gateway -o jsonpath='{.items[0].metadata.name}') -- npm run migration:run
```

## Monitoring and Logging

### Setting up Monitoring Stack

```bash
# Deploy monitoring stack with Docker Compose
$ docker-compose -f infrastructure/monitoring/docker-compose.monitoring.yml up -d

# Deploy monitoring stack with Kubernetes
$ kubectl apply -f infrastructure/monitoring/prometheus.yml
$ kubectl apply -f infrastructure/monitoring/grafana.yml
$ kubectl apply -f infrastructure/monitoring/loki.yml
$ kubectl apply -f infrastructure/monitoring/tempo.yml
```

### Accessing Monitoring Dashboards

- Prometheus: http://localhost:9090 (or your domain/ingress path)
- Grafana: http://localhost:3000 (or your domain/ingress path)
- Default Grafana credentials: admin/admin (change after first login)

## Continuous Deployment

### Setting up CI/CD Pipeline

Example GitHub Actions workflow:

```yaml
name: Deploy to Production

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v1
    
    - name: Login to Container Registry
      uses: docker/login-action@v1
      with:
        registry: your-registry
        username: ${{ secrets.REGISTRY_USERNAME }}
        password: ${{ secrets.REGISTRY_PASSWORD }}
    
    - name: Build and push Docker images
      run: |
        docker-compose -f infrastructure/docker/docker-compose.yml build
        docker tag instagram-clone/api-gateway:latest your-registry/instagram-clone/api-gateway:latest
        docker tag instagram-clone/user-service:latest your-registry/instagram-clone/user-service:latest
        # ... tag other services
        docker push your-registry/instagram-clone/api-gateway:latest
        docker push your-registry/instagram-clone/user-service:latest
        # ... push other services
    
    - name: Deploy to Kubernetes
      uses: steebchen/kubectl@v2
      with:
        config: ${{ secrets.KUBE_CONFIG_DATA }}
        command: apply -f infrastructure/k8s/
```

## Rollback Procedure

### Rolling Back Docker Compose Deployments

```bash
# Roll back to a previous version
$ docker-compose -f infrastructure/docker/docker-compose.prod.yml down
$ docker tag your-registry/instagram-clone/api-gateway:previous your-registry/instagram-clone/api-gateway:latest
# ... tag other services with previous versions
$ docker-compose -f infrastructure/docker/docker-compose.prod.yml up -d
```

### Rolling Back Kubernetes Deployments

```bash
# Roll back to a previous deployment
$ kubectl rollout undo deployment/api-gateway
$ kubectl rollout undo deployment/user-service
# ... roll back other deployments

# Roll back to a specific revision
$ kubectl rollout undo deployment/api-gateway --to-revision=2
```

## Backup and Restore

### Database Backup

```bash
# For PostgreSQL
$ docker exec -t postgres pg_dump -U postgres instagram_clone > backup.sql

# In Kubernetes
$ kubectl exec -t $(kubectl get pods -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- pg_dump -U postgres instagram_clone > backup.sql
```

### Database Restore

```bash
# For PostgreSQL
$ cat backup.sql | docker exec -i postgres psql -U postgres instagram_clone

# In Kubernetes
$ cat backup.sql | kubectl exec -i $(kubectl get pods -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- psql -U postgres instagram_clone
```

## SSL/TLS Configuration

### Configuring SSL with Docker Compose

Update the `docker-compose.prod.yml` file to include SSL certificates:

```yaml
services:
  api-gateway:
    # ... other configuration
    volumes:
      - ./ssl/cert.pem:/app/ssl/cert.pem
      - ./ssl/key.pem:/app/ssl/key.pem
    environment:
      - SSL_CERT_PATH=/app/ssl/cert.pem
      - SSL_KEY_PATH=/app/ssl/key.pem
```

### Configuring SSL with Kubernetes

Create a TLS secret and update the ingress configuration:

```bash
$ kubectl create secret tls instagram-clone-tls --cert=./ssl/cert.pem --key=./ssl/key.pem
```

Update the ingress.yaml file:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: instagram-clone-ingress
spec:
  tls:
  - hosts:
    - api.instagram-clone.com
    secretName: instagram-clone-tls
  rules:
  - host: api.instagram-clone.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-gateway
            port:
              number: 80
```

## Troubleshooting

### Common Issues and Solutions

1. **Services can't connect to each other**
   - Check network configuration
   - Verify service names and ports
   - Ensure DNS resolution is working

2. **Database connection failures**
   - Verify connection strings
   - Check database credentials
   - Ensure database service is running

3. **Container crashes on startup**
   - Check logs: `docker logs <container_id>` or `kubectl logs <pod_name>`
   - Verify environment variables
   - Check for missing dependencies

### Viewing Logs

```bash
# Docker Compose logs
$ docker-compose -f infrastructure/docker/docker-compose.prod.yml logs -f api-gateway

# Kubernetes logs
$ kubectl logs -f deployment/api-gateway
```

## Security Considerations

1. **Secrets Management**
   - Use Kubernetes Secrets or Docker Secrets for sensitive information
   - Never commit .env files with real credentials to version control
   - Consider using a secrets management solution like HashiCorp Vault

2. **Network Security**
   - Use network policies to restrict communication between services
   - Implement proper firewall rules
   - Use private networks for internal services

3. **Container Security**
   - Regularly update base images
   - Scan images for vulnerabilities
   - Run containers with minimal privileges

## Performance Optimization

1. **Resource Allocation**
   - Set appropriate CPU and memory limits for containers
   - Monitor resource usage and adjust as needed

2. **Caching**
   - Configure Redis caching appropriately
   - Set proper TTL values for cached items

3. **Database Optimization**
   - Create necessary indexes
   - Optimize queries
   - Consider read replicas for high-traffic deployments

## Conclusion

This deployment guide covers the basics of deploying the Instagram Clone backend services. For more specific requirements or advanced configurations, consult with your DevOps team or infrastructure specialists.