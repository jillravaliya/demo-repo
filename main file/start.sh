#!/bin/bash

echo "🚀 Starting Daily Activity Tracker..."

# Exit on any error
set -e

# Build the application if .next directory doesn't exist
if [ ! -d ".next" ]; then
    echo "📦 Building application..."
    npm run build
fi

# Start the application
echo "▶️ Starting Next.js server..."
exec node_modules/.bin/next start -p 3000
