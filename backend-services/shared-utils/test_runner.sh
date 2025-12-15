#!/bin/bash

# Test runner script for shared-utils package
echo "🚀 Running all tests for shared-utils package..."

# Navigate to the package directory
cd "$(dirname "$0")"

# Run all unit tests
echo "🧪 Running unit tests..."
npm test

# Check if tests passed
if [ $? -eq 0 ]; then
    echo "✅ All tests passed!"
else
    echo "❌ Some tests failed!"
    exit 1
fi