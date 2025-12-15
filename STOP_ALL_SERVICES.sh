#!/bin/bash

# Stop Script for Uber Clone Project
# This script stops all running backend services and frontend web servers

echo "🛑 Stopping Uber Clone Services..."

# Kill all node and python http server processes
pkill -f "node simple_server.js"
pkill -f "python3 -m http.server 3010"
pkill -f "python3 -m http.server 3011"
pkill -f "python3 -m http.server 3012"

echo "✅ All services stopped successfully!"

# Show remaining processes (if any)
echo ""
echo "🔍 Checking for remaining processes..."
ps aux | grep -E "(node|python3.*http\.server)" | grep -v grep || echo "No remaining processes found"