# Multi-stage Dockerfile for Xavante Worker (Laravel Zero)

# Build stage
FROM php:8.2-cli-alpine AS builder

# Install system dependencies
RUN apk add --no-cache \
    git \
    unzip \
    libzip-dev \
    && docker-php-ext-install zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy the entire project structure to have access to lib/core
COPY ./src ./build-context

# Copy composer files first for better layer caching
# COPY app/composer.json app/composer.lock ./
COPY src/composer.json  ./

# Install PHP dependencies
# RUN composer install --no-dev --no-scripts --no-autoloader --optimize-autoloader

# Copy application code
COPY src/ ./

# Generate optimized autoloader
RUN composer dump-autoload --optimize --no-dev

# Production stage
FROM php:8.2-cli-alpine AS production

# Install runtime dependencies
RUN apk add --no-cache \
    libzip \
    && rm -rf /var/cache/apk/*

# Create non-root user
RUN addgroup -g 1001 -S worker && \
    adduser -S worker -u 1001 -G worker

# Set working directory
WORKDIR /app

# Copy application from builder stage
COPY --from=builder --chown=worker:worker /app /app

# Make worker executable
RUN chmod +x /app/xavante

# Create directories for logs and cache
RUN mkdir -p /app/storage/logs /app/storage/cache && \
    chown -R worker:worker /app/storage

# Switch to non-root user
USER worker

# Set environment
ENV APP_ENV=production

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD php xavante list || exit 1

# Default command
ENTRYPOINT [ "sleep", "infinity" ]
# ENTRYPOINT ["php", "/app/xavante"]
# CMD ["worker:run"]