#!/bin/bash

# Exit on error
set -e

# Check if service name is provided
if [ "$1" != "" ]; then
  SERVICE=$1
  echo "Running tests for $SERVICE..."
  
  if [ "$SERVICE" == "api-gateway" ]; then
    cd api-gateway
    npm test
  elif [ "$SERVICE" == "common" ]; then
    cd libs/common
    npm test
  elif [ -d "services/$SERVICE" ]; then
    cd services/$SERVICE
    npm test
  else
    echo "Service $SERVICE not found!"
    exit 1
  fi
  
  exit 0
fi

# Run all tests
echo "Running all tests..."

# Run common library tests
echo "Testing common library..."
cd libs/common
npm test
cd ../..

# Run API Gateway tests
echo "Testing API Gateway..."
cd api-gateway
npm test
cd ..

# Run all service tests
echo "Testing services..."
cd services

for service in */; do
  if [ -d "$service" ]; then
    echo "Testing $service..."
    cd "$service"
    npm test
    cd ..
  fi
done

cd ..

# Run integration tests
echo "Running integration tests..."
npm run test:integration

echo "All tests completed successfully!"