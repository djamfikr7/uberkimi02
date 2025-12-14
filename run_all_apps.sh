#!/bin/bash

# Script to run all three Uber Clone apps simultaneously for development
# This script opens three terminal tabs/windows and runs each app

echo "Starting all Uber Clone apps..."

# Create a temporary directory for logs
mkdir -p /tmp/uber_clone_logs

# Function to run app in background and log output
run_app() {
    local app_name=$1
    local app_path=$2
    local log_file="/tmp/uber_clone_logs/${app_name}.log"
    
    echo "Starting $app_name..."
    echo "Logs will be saved to $log_file"
    
    # Run the app in background and redirect output to log file
    cd "$app_path" && flutter run -d chrome > "$log_file" 2>&1 &
    
    # Save the process ID
    echo $! > "/tmp/uber_clone_logs/${app_name}_pid"
    
    echo "$app_name started with PID $!"
}

# Run all three apps
run_app "rider_app" "/media/fi/NewVolume/project01/UberKimi01/uberkimi02/flutter-apps/rider_app"
run_app "driver_app" "/media/fi/NewVolume/project01/UberKimi01/uberkimi02/flutter-apps/driver_app"
run_app "admin_app" "/media/fi/NewVolume/project01/UberKimi01/uberkimi02/flutter-apps/admin_app"

echo ""
echo "All apps started!"
echo "Check logs in /tmp/uber_clone_logs/"
echo ""
echo "To stop all apps, run:"
echo "  pkill -f 'flutter run'"
echo ""
echo "To view logs:"
echo "  tail -f /tmp/uber_clone_logs/*.log"

# Wait for user input to keep script running
echo ""
echo "Press Ctrl+C to exit this script (apps will continue running)"
while true; do
    sleep 60
done