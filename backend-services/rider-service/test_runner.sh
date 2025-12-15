#!/bin/bash

# Test runner script for rider-service
echo "🚀 Running all tests for rider-service..."

# Navigate to the service directory
cd "$(dirname "$0")"

# Install supertest for integration tests
echo "📦 Installing supertest..."
npm install --save-dev supertest

# Run all unit tests
echo "🧪 Running unit tests..."
npm test

# Check if unit tests passed
if [ $? -eq 0 ]; then
    echo "✅ Unit tests passed!"
else
    echo "❌ Unit tests failed!"
    exit 1
fi

# Run integration tests
echo "🧪 Running integration tests..."
jest __tests__/integration

# Check if integration tests passed
if [ $? -eq 0 ]; then
    echo "✅ Integration tests passed!"
else
    echo "❌ Integration tests failed!"
    exit 1
fi

echo "🎉 All tests completed successfully!"