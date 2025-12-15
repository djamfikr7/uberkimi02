#!/bin/bash

# Test runner script for uber_shared package
echo "🚀 Running all tests for uber_shared package..."

# Navigate to the package directory
cd "$(dirname "$0")"

# Run all widget tests
echo "🧪 Running widget tests..."
flutter test test/

# Check if tests passed
if [ $? -eq 0 ]; then
    echo "✅ All tests passed!"
else
    echo "❌ Some tests failed!"
    exit 1
fi