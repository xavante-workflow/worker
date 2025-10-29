# Xavante Worker

A **Laravel Zero** powered worker component for the Xavante Workflow Engine that processes workflow instances and simulates the complete workflow execution lifecycle.

## 🎯 Purpose

The Xavante Worker is designed to:

- **Import workflow definitions** from the Xavante core library
- **Create and manage workflow processes** programmatically
- **Iterate through workflow execution** steps
- **Trigger events and update variables** during execution
- **Evaluate and generate execution logs** for monitoring and debugging

This worker serves as a simulation and testing tool for workflow processes, allowing developers to validate workflow definitions and observe their behavior in a controlled environment.

## 🏗️ Architecture

The worker leverages **Laravel Zero** framework and the **Xavante Core Library** (`xavante/core`) which provides:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Laravel Zero   │────│  Xavante Worker │────│  Xavante Core   │
│                 │    │                 │    │                 │
│  • CLI Framework│    │  • Commands     │    │  • Models       │
│  • Artisan      │    │  • Process Exec │    │  • Actions      │
│  • Service Cont │    │  • Scheduling   │    │  • Conditions   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Getting Started

### Prerequisites

- PHP 8.2 or higher
- Composer
- Docker (optional, for containerized deployment)

## 📦 Installation Methods

### Method 1: Local Development

1. **Navigate to the worker directory:**
   ```bash
   cd worker/app
   ```

2. **Install dependencies:**
   ```bash
   composer install
   ```

3. **Run the worker:**
   ```bash
   php worker worker:run
   ```

### Method 2: Docker Deployment

1. **Using Docker Compose (Recommended):**
   ```bash
   # Production deployment
   docker-compose up -d xavante-worker
   
   # Development with hot reload
   docker-compose --profile development up -d xavante-worker-dev
   ```

2. **Using Docker directly:**
   ```bash
   # Build the image
   docker build -t xavante/worker:latest .
   
   # Run the container
   docker run --rm xavante/worker:latest worker:run
   ```

## 📁 Project Structure (Laravel Zero)

```
worker/
├── app/
│   ├── app/
│   │   ├── Console/
│   │   │   ├── Commands/           # Laravel Zero Artisan commands
│   │   │   │   ├── WorkerCommand.php   # Main worker command
│   │   │   │   └── ProcessCommand.php  # Workflow processing command
│   │   │   └── Kernel.php         # Console kernel
│   │   └── Providers/
│   │       └── AppServiceProvider.php
│   ├── bootstrap/
│   │   └── app.php                # Application bootstrap
│   ├── config/
│   │   └── app.php                # Application configuration
│   ├── routes/
│   │   └── console.php            # Console routes
│   ├── composer.json              # Laravel Zero dependencies
│   └── worker                     # Artisan executable
├── docker-compose.yml             # Docker orchestration
├── Dockerfile                     # Multi-stage Docker build
├── .env.example                   # Environment configuration template
└── README.md                      # This file
```

## 🔧 Configuration

### Environment Configuration

Copy the environment template and customize:
```bash
cp .env.example .env
```

Edit `.env` file:
```env
APP_ENV=production
APP_NAME="Xavante Worker"
APP_VERSION=1.0.0
APP_DEBUG=false
```

### Composer Configuration

The worker uses Laravel Zero framework with the following key dependencies:

```json
{
    "require": {
        "php": "^8.2",
        "laravel-zero/framework": "^11.0",
        "guzzlehttp/guzzle": "^7.10",
        "xavante/core": "dev-main"
    }
}
```

## 🚀 Available Commands

### Laravel Zero Artisan Commands

```bash
# List all available commands
php xavante list

# Run the main worker command
php xavante worker:run

# Run worker with JSON output format
php xavante worker:run --format=json

# Process workflows (simulation)
php xavante process

# Process specific workflow
php xavante process --workflow-id=12345

# Process with verbose output
php xavante process --verbose

# Show application information
php xavante app:version
```

### Docker Commands

```bash
# Production deployment
docker-compose up -d

# Development mode with hot reload
docker-compose --profile development up -d

# View logs
docker-compose logs -f xavante-worker

# Execute commands in running container
docker-compose exec xavante-worker php worker list

# Stop services
docker-compose down

# Rebuild and restart
docker-compose down && docker-compose build && docker-compose up -d
```

## 🛠️ Development

### Local Development Setup

1. **Install dependencies:**
   ```bash
   cd app && composer install
   ```

2. **Run in development mode:**
   ```bash
   php worker worker:run --verbose
   ```

3. **Watch for changes (using Docker):**
   ```bash
   docker-compose --profile development up -d xavante-worker-dev
   ```

### Adding New Commands

Create new Laravel Zero commands in `app/Console/Commands/`:

```php
<?php

namespace App\Console\Commands;

use LaravelZero\Framework\Commands\Command;

class YourCommand extends Command
{
    protected $signature = 'your:command {argument} {--option}';
    protected $description = 'Description of your command';

    public function handle(): int
    {
        $this->info('Your command logic here');
        return self::SUCCESS;
    }
}
```

## 🐳 Docker Configuration

### Multi-stage Dockerfile

The project uses a multi-stage Docker build:

- **Builder stage**: Installs Composer dependencies and builds the application
- **Production stage**: Creates a minimal runtime image with only necessary files

### Docker Compose Services

- **xavante-worker**: Production service with resource limits and health checks
- **xavante-worker-dev**: Development service with volume mounts for hot reload

### Health Checks

The container includes health checks to ensure the application is running properly:
```bash
# Manual health check
docker exec xavante-worker php worker list
```

## 🔍 Monitoring & Logging

### Application Logs

View application logs:
```bash
# Docker logs
docker-compose logs -f xavante-worker

# Application output
php worker worker:run --verbose
```

### Health Status

Check container health:
```bash
# Container status
docker-compose ps

# Health check
docker inspect xavante-worker --format='{{.State.Health.Status}}'
```

## 🧪 Testing

Run tests using PHPUnit:
```bash
# Local testing
cd app && ./vendor/bin/phpunit

# Docker testing
docker-compose exec xavante-worker ./vendor/bin/phpunit
```

## 🚢 Deployment

### Production Deployment

1. **Build and deploy:**
   ```bash
   # Pull latest changes
   git pull origin main
   
   # Build and start services
   docker-compose build --no-cache
   docker-compose up -d
   ```

2. **Verify deployment:**
   ```bash
   # Check service status
   docker-compose ps
   
   # Test command execution
   docker-compose exec xavante-worker php worker worker:run
   ```

### Scaling

Scale the worker service:
```bash
# Scale to 3 instances
docker-compose up -d --scale xavante-worker=3
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:

- Create an issue in the repository
- Contact: xavante@eduardo-luz.com

## 🔄 Changelog

### v1.0.0 (Laravel Zero Migration)
- ✅ Migrated to Laravel Zero framework
- ✅ Added Docker support with multi-stage builds
- ✅ Created Artisan commands for workflow processing
- ✅ Added comprehensive documentation
- ✅ Implemented health checks and monitoring
- ✅ Added development and production environments

1. Create new classes under the `src/` directory with the `Xavante\Worker\` namespace
2. Follow PSR-4 autoloading conventions
3. Use the core library's models and services through proper imports

### Example Usage

```php
<?php

namespace Xavante\Worker;

use Xavante\Models\Domain\Workflow;

// Load dependencies
include_once __DIR__ . '/vendor/autoload.php';

// Create new workflow instance
$workflow = new Workflow([
    'name' => 'Sample Workflow',
    'version' => '1.0.0'
]);

// Process the workflow
$result = $workflow->jsonSerialize();
print_r($result);
```

### Testing

Run tests using PHPUnit:

```bash
vendor/bin/phpunit
```

## 🔗 Integration with Xavante Ecosystem

The worker integrates seamlessly with other Xavante components:

- **Xavante Server**: Can be used to test workflows before deployment to the main server
- **Xavante Core**: Directly uses core models, actions, and runtime components
- **API Endpoints**: Can simulate the same processes that would be triggered via REST API

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the main project's LICENSE file for details.

## 🏛️ About Xavante

This project is part of the Xavante Workflow Engine, named as a tribute to the Xavante people of Brazil—honoring their strength, resilience, and rich cultural heritage that continues to inspire even in modern technology.

For more information about the complete Xavante Workflow Engine, visit the [main repository](../../README.md).