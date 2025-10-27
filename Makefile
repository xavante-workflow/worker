# Xavante Worker - Development Makefile

.PHONY: help install build start stop restart logs shell test clean

# Default target
.DEFAULT_GOAL := help

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(GREEN)Xavante Worker - Available Commands:$(NC)"
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'
	@echo

install: ## Install dependencies locally
	@echo "$(GREEN)Installing dependencies...$(NC)"
	cd app && composer install

build: ## Build Docker images
	@echo "$(GREEN)Building Docker images...$(NC)"
	docker-compose build --no-cache

start: ## Start services in production mode
	@echo "$(GREEN)Starting production services...$(NC)"
	docker-compose up -d xavante-worker

start-dev: ## Start services in development mode
	@echo "$(GREEN)Starting development services...$(NC)"
	docker-compose --profile development up -d xavante-worker-dev

stop: ## Stop all services
	@echo "$(YELLOW)Stopping services...$(NC)"
	docker-compose down

restart: stop start ## Restart services

logs: ## View logs from running services
	@echo "$(GREEN)Showing logs...$(NC)"
	docker-compose logs -f

logs-dev: ## View development logs
	@echo "$(GREEN)Showing development logs...$(NC)"
	docker-compose logs -f xavante-worker-dev

shell: ## Access shell in running container
	@echo "$(GREEN)Accessing container shell...$(NC)"
	docker-compose exec xavante-worker /bin/sh

shell-dev: ## Access shell in development container
	@echo "$(GREEN)Accessing development container shell...$(NC)"
	docker-compose exec xavante-worker-dev /bin/sh

test: ## Run tests
	@echo "$(GREEN)Running tests...$(NC)"
	cd app && ./vendor/bin/phpunit

test-docker: ## Run tests in Docker
	@echo "$(GREEN)Running tests in Docker...$(NC)"
	docker-compose exec xavante-worker ./vendor/bin/phpunit

run: ## Run worker command locally
	@echo "$(GREEN)Running worker locally...$(NC)"
	cd app && php worker worker:run

run-docker: ## Run worker command in Docker
	@echo "$(GREEN)Running worker in Docker...$(NC)"
	docker-compose exec xavante-worker php worker worker:run

process: ## Run process command locally
	@echo "$(GREEN)Running process command locally...$(NC)"
	cd app && php worker process --verbose

process-docker: ## Run process command in Docker
	@echo "$(GREEN)Running process command in Docker...$(NC)"
	docker-compose exec xavante-worker php worker process --verbose

status: ## Show service status
	@echo "$(GREEN)Service Status:$(NC)"
	docker-compose ps

health: ## Check container health
	@echo "$(GREEN)Health Check:$(NC)"
	@docker inspect xavante-worker --format='{{.State.Health.Status}}' 2>/dev/null || echo "Container not running"

clean: ## Clean up containers, images, and volumes
	@echo "$(YELLOW)Cleaning up...$(NC)"
	docker-compose down -v --remove-orphans
	docker system prune -f

clean-all: clean ## Clean everything including images
	@echo "$(RED)Removing all images...$(NC)"
	docker-compose down -v --rmi all --remove-orphans

setup: ## Complete setup (install, build, start)
	@echo "$(GREEN)Complete setup...$(NC)"
	$(MAKE) install
	$(MAKE) build
	$(MAKE) start

setup-dev: ## Complete development setup
	@echo "$(GREEN)Complete development setup...$(NC)"
	$(MAKE) install
	$(MAKE) build
	$(MAKE) start-dev

update: ## Update dependencies and restart
	@echo "$(GREEN)Updating...$(NC)"
	cd app && composer update
	$(MAKE) build
	$(MAKE) restart

deploy: ## Deploy to production
	@echo "$(GREEN)Deploying to production...$(NC)"
	git pull origin main
	$(MAKE) build
	$(MAKE) start
	$(MAKE) health