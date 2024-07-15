#!/usr/bin/env bash

set -e

echo "Waiting for PostgreSQL to be ready..."
sleep 15

echo "Starting pg_sync..."

# Example of running commands with error handling
bootstrap --config ./schema.json
pgsync --config ./schema.json -d

echo "pg_sync finished successfully."