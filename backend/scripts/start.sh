#!/bin/bash

# Exit on error
set -e

# Check if service name is provided
if [ "$1" != "" ]; then
  SERVICE=$1
  echo "Starting $SERVICE..."
  
  if [ "$SERVICE" == "api-gateway" ]; then
    cd api-gateway
    npm run start:dev
  elif [ -d "services/$SERVICE" ]; then
    cd services/$SERVICE
    npm run start:dev
  else
    echo "Service $SERVICE not found!"
    exit 1
  fi
  
  exit 0
fi

# Start all services in development mode
echo "Starting all services in development mode..."

# Start API Gateway
echo "Starting API Gateway..."
cd api-gateway
npm run start:dev &
cd ..

# Start all services
echo "Starting services..."
cd services

for service in */; do
  if [ -d "$service" ]; then
    echo "Starting $service..."
    cd "$service"
    npm run start:dev &
    cd ..
  fi
done

cd ..

echo "All services started successfully!"

# Wait for all background processes
wait