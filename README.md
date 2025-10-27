# Xavante Worker

A PHP-based worker component for the Xavante Workflow Engine that processes workflow instances and simulates the complete workflow execution lifecycle.

## 🎯 Purpose

The Xavante Worker is designed to:

- **Import workflow definitions** from the Xavante core library
- **Create and manage workflow processes** programmatically
- **Iterate through workflow execution** steps
- **Trigger events and update variables** during execution
- **Evaluate and generate execution logs** for monitoring and debugging

This worker serves as a simulation and testing tool for workflow processes, allowing developers to validate workflow definitions and observe their behavior in a controlled environment.

## 🏗️ Architecture

The worker leverages the **Xavante Core Library** (`xavante/core`) which provides:
- Workflow models and domain objects
- Action execution logic
- Condition evaluation systems
- Runtime execution environment

```
┌─────────────────┐    ┌─────────────────┐
│  Xavante Worker │────│  Xavante Core   │
│                 │    │                 │
│  • Process Exec │    │  • Models       │
│                 │    │  • Actions      │
│                 │    │  • Conditions   │
│                 │    │  • Runtime      │
└─────────────────┘    └─────────────────┘
```

## 🚀 Getting Started

### Prerequisites

- PHP 8.2 or higher
- Composer

### Installation

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
   php worker.php
   ```

## 📁 Project Structure

```
worker/
├── app/
│   ├── composer.json          # Dependencies and autoloading
│   ├── composer.lock          # Locked dependency versions
│   ├── worker.php            # Main worker entry point
│   └── vendor/               # Composer dependencies
│       └── xavante/core/     # Xavante core library (symlinked)
├── description.md            # Project description
└── README.md                # This file
```

## 🔧 Configuration

The worker is configured through its `composer.json` file:

- **Core Library Integration**: Uses a path repository to include the local `xavante/core` library
- **Autoloading**: PSR-4 autoloading for `Xavante\Worker\` namespace
- **Dependencies**: Includes Guzzle HTTP client and PHPUnit for testing

### Composer Configuration Highlights

```json
{
    "repositories": [
        {
            "type": "path",
            "url": "../../lib/core"
        }
    ],
    "require": {
        "xavante/core": "dev-main"
    },
    "minimum-stability": "dev",
    "prefer-stable": true
}
```

## 🛠️ Development

### Adding New Features

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