#!/bin/bash

# Quick Start Script for Uber Clone Project
# This script starts all backend services and frontend web servers

echo "🚀 Starting Uber Clone Services..."

# Start the main backend API server (port 3000)
echo "Starting main API server on port 3000..."
cd /media/fi/NewVolume1/project01/UberKimi01/uberkimi02/backend-services/rider-service
node simple_server.js > /tmp/uber_api.log 2>&1 &
API_PID=$!
echo "✅ API Server started (PID: $API_PID)"

# Wait a moment for the API server to start
sleep 3

# Start Rider App Web Server (port 3010)
echo "Starting Rider App on port 3010..."
cd /media/fi/NewVolume1/project01/UberKimi01/uberkimi02/flutter-apps/rider_app/build/web
python3 -m http.server 3010 > /tmp/uber_rider.log 2>&1 &
RIDER_PID=$!
echo "✅ Rider App started (PID: $RIDER_PID)"

# Start Driver App Web Server (port 3011)
echo "Starting Driver App on port 3011..."
cd /media/fi/NewVolume1/project01/UberKimi01/uberkimi02/flutter-apps/driver_app/build/web
python3 -m http.server 3011 > /tmp/uber_driver.log 2>&1 &
DRIVER_PID=$!
echo "✅ Driver App started (PID: $DRIVER_PID)"

# Start Admin App Web Server (port 3012)
echo "Starting Admin App on port 3012..."
cd /media/fi/NewVolume1/project01/UberKimi01/uberkimi02/flutter-apps/admin_app/build/web
python3 -m http.server 3012 > /tmp/uber_admin.log 2>&1 &
ADMIN_PID=$!
echo "✅ Admin App started (PID: $ADMIN_PID)"

echo ""
echo "🎯 All services started successfully!"
echo ""
echo "🔌 Service URLs:"
echo "   Main API: http://localhost:3000/api"
echo "   Rider App: http://localhost:3010"
echo "   Driver App: http://localhost:3011"
echo "   Admin App: http://localhost:3012"
echo ""
echo "🔐 Demo Credentials:"
echo "   Rider: POST http://localhost:3000/api/auth/demo/login/rider"
echo "   Driver: POST http://localhost:3000/api/auth/demo/login/driver"
echo "   Admin: POST http://localhost:3000/api/auth/demo/login/admin"
echo ""
echo "🛑 To stop all services, run: pkill -f 'node\|python3 -m http.server'"