# Instagram Microservices Makefile

.PHONY: help setup start stop build test lint clean deploy logs

help: ## Display this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk -F ':|##' '/^[^\t].+?:.*?##/ {\printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF}' $(MAKEFILE_LIST)

setup: ## Initial setup of the project
	@echo "Setting up the project..."
	@cp -n .env.example .env || true
	@echo "Environment file created. Please update the values in .env file."

start: ## Start all services in development mode
	@echo "Starting all services..."
	docker-compose up

start-detached: ## Start all services in detached mode
	@echo "Starting all services in detached mode..."
	docker-compose up -d

start-prod: ## Start all services in production mode
	@echo "Starting all services in production mode..."
	docker-compose -f docker-compose.prod.yml up -d

stop: ## Stop all services
	@echo "Stopping all services..."
	docker-compose down

stop-prod: ## Stop all production services
	@echo "Stopping all production services..."
	docker-compose -f docker-compose.prod.yml down

build: ## Build all services
	@echo "Building all services..."
	docker-compose build

build-prod: ## Build all services for production
	@echo "Building all services for production..."
	docker-compose -f docker-compose.prod.yml build

test: ## Run tests for all services
	@echo "Running tests for all services..."
	npm test

lint: ## Run linting for all services
	@echo "Running linting for all services..."
	npm run lint

clean: ## Clean up resources
	@echo "Cleaning up resources..."
	docker-compose down -v
	rm -rf services/*/node_modules
	rm -rf services/*/dist
	rm -rf libs/*/node_modules
	rm -rf libs/*/dist

deploy: ## Deploy to production
	@echo "Deploying to production..."
	@echo "This command should be implemented based on your deployment strategy."
	@echo "For example, it could push to a container registry and trigger a Kubernetes deployment."

logs: ## View logs of all services
	@echo "Viewing logs of all services..."
	docker-compose logs -f

logs-service: ## View logs of a specific service (usage: make logs-service SERVICE=api-gateway)
	@echo "Viewing logs of $(SERVICE)..."
	docker-compose logs -f $(SERVICE)

generate-service: ## Generate a new service (usage: make generate-service SERVICE=new-service)
	@echo "Generating new service: $(SERVICE)..."
	mkdir -p services/$(SERVICE)/src
	mkdir -p services/$(SERVICE)/test
	@echo "Service $(SERVICE) created. Please implement the required files."