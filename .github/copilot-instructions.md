# Copilot Instructions for Xavante Worker

## Architecture Overview

This is a **Laravel Zero** CLI application that serves as a workflow processing worker for the Xavante Workflow Engine. Key architectural patterns:

- **Laravel Zero Framework**: Console-only Laravel application with Artisan commands
- **External Core Library**: Depends on `xavante/core` (local path dependency at `/app/lib/core`)
- **Docker-First Development**: Multi-stage Dockerfile with production and development profiles
- **Cultural Naming**: Uses Xavante indigenous terminology (Imama, Uiwede, Wara) for components

## Project Structure & Key Files

```
src/                              # Main application directory
├── app/Console/Commands/         # Laravel Zero Artisan commands
│   ├── WorkerCommand.php        # Main worker:run command
│   └── ProcessCommand.php       # Workflow processing command
├── composer.json                # Dependencies including xavante/core
├── xavante                      # Artisan CLI executable (entry point)
└── lib/core/                    # Mounted xavante/core library
```

## Development Workflows

### Running Commands
- **Local**: `php xavante <command>` (from src/ directory)
- **Docker Production**: `docker-compose exec xavante-worker php xavante <command>`
- **Docker Development**: `docker-compose --profile development up -d`

### Key Commands
- `php xavante worker:run` - Main workflow processor
- `php xavante worker:run --format=json` - JSON output format
- `php xavante worker process --workflow-id=12345` - Process specific workflow
- `php xavante worker list` - Show all available commands

### Docker Development
- Development mode mounts `./src:/app` for hot reload
- Core library mounted from `../lib/core:/app/lib/core`
- Use `docker-compose --profile development` for dev environment

## Code Patterns & Conventions

### Laravel Zero Command Structure
```php
class WorkerCommand extends Command
{
    protected $signature = 'worker:run {--format=table : Output format}';
    protected $description = 'Run the Xavante Worker';
    
    public function handle(): int
    {
        // Use emoji prefixes for user-friendly output
        $this->info('🚀 Starting Xavante Worker...');
        
        // Return Command constants
        return self::SUCCESS; // or self::FAILURE
    }
}
```

### Xavante Core Integration
- Import models: `use Xavante\Models\Domain\Workflow;`
- Create instances: `$workflow = new Workflow([]);`
- Access data: `$workflowData = $workflow->jsonSerialize();`

### Output Formatting
- Use emoji prefixes consistently: 🚀 🔄 📋 ⚡ 📤 📊 ✅ ❌
- Support `--format=json` option for programmatic output
- Use Laravel's `$this->table()` for tabular data
- Handle errors with try/catch and descriptive messages

## Dependencies & Integration Points

### Core Dependencies
- `laravel-zero/framework: ^11.0` - CLI framework
- `xavante/core: dev-main` - Local path dependency for workflow models
- `guzzlehttp/guzzle: ^7.10` - HTTP client for external integrations

### External Integrations
- **Xavante Server**: Can simulate server workflows for testing
- **API Endpoints**: Mimics REST API workflow processes
- **Docker Ecosystem**: Integrates with broader Xavante container stack

## Docker & Deployment

### Multi-Stage Build Pattern
- **Builder stage**: `php:8.2-cli-alpine` with Composer for dependency installation
- **Production stage**: Minimal runtime with non-root user (worker:1001)
- Health checks via `php xavante list`

### Volume Mounts (Development)
- `./src:/app` - Source code hot reload
- `../lib/core:/app/lib/core` - Core library dependency
- `worker_storage:/app/storage` - Persistent storage

### Environment Variables
- `APP_ENV=production` - Environment setting
- `APP_NAME="Xavante Worker"` - Application name
- `APP_VERSION=1.0.0` - Version identifier

## Testing & Quality

- PHPUnit configured: `./vendor/bin/phpunit`
- Docker testing: `docker-compose exec xavante-worker ./vendor/bin/phpunit`
- Health checks ensure container readiness
- Makefile provides common development commands

## Cultural Context

The project honors the Xavante indigenous people of Brazil through meaningful naming:
- **Imama** (Orchestrator) - Community watchers/directors
- **Uiwede** (Worker) - Seasonal log races representing coordinated task execution  
- **Wara** (UI Management) - Traditional forum for discussion

When extending the system, respect this cultural foundation by using meaningful metaphors rather than generic technical terms.