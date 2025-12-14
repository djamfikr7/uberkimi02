#!/bin/bash

# Script to start all backend services and frontend apps

echo "🚀 Starting Uber Clone Services..."

# Start backend services in background
echo "Starting Rider Service on port 3001..."
cd backend-services/rider-service && npm start > /tmp/rider-service.log 2>&1 &
RIDER_SERVICE_PID=$!

echo "Starting Driver Service on port 3002..."
cd ../driver-service && npm start > /tmp/driver-service.log 2>&1 &
DRIVER_SERVICE_PID=$!

echo "Starting Admin Service on port 3003..."
cd ../admin-service && npm start > /tmp/admin-service.log 2>&1 &
ADMIN_SERVICE_PID=$!

# Wait a moment for services to start
sleep 5

# Check if services are running
if lsof -i :3001 >/dev/null; then
  echo "✅ Rider Service is running on port 3001"
else
  echo "❌ Rider Service failed to start"
  cat /tmp/rider-service.log
fi

if lsof -i :3002 >/dev/null; then
  echo "✅ Driver Service is running on port 3002"
else
  echo "❌ Driver Service failed to start"
  cat /tmp/driver-service.log
fi

if lsof -i :3003 >/dev/null; then
  echo "✅ Admin Service is running on port 3003"
else
  echo "❌ Admin Service failed to start"
  cat /tmp/admin-service.log
fi

echo ""
echo "🔧 To start Flutter apps, run these commands in separate terminals:"
echo "   cd flutter-apps/rider_app && flutter run -d chrome --web-port 3010"
echo "   cd flutter-apps/driver_app && flutter run -d chrome --web-port 3011"
echo "   cd flutter-apps/admin_app && flutter run -d chrome --web-port 3012"
echo ""
echo "🛑 Press Ctrl+C to stop backend services"

# Wait for user to stop services
wait $RIDER_SERVICE_PID $DRIVER_SERVICE_PID $ADMIN_SERVICE_PID