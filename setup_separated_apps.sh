#!/bin/bash

# Setup script for the separated Uber Clone applications

echo "Setting up separated Uber Clone applications..."

# Setup backend services
echo "Setting up backend services..."

cd backend-services/rider-service
echo "Installing Rider Service dependencies..."
npm install
cd ../driver-service
echo "Installing Driver Service dependencies..."
npm install
cd ../admin-service
echo "Installing Admin Service dependencies..."
npm install

# Setup frontend applications
echo "Setting up frontend applications..."

cd ../../flutter-apps/rider_app
echo "Installing Rider App dependencies..."
flutter pub get

cd ../driver_app
echo "Installing Driver App dependencies..."
flutter pub get

cd ../admin_app
echo "Installing Admin App dependencies..."
flutter pub get

# Setup shared package
echo "Setting up shared package..."

cd ../../flutter-packages/uber_shared
echo "Getting shared package dependencies..."
flutter pub get

echo "Setup complete!"
echo ""
echo "Next steps:"
echo "1. Configure environment variables in each backend service"
echo "2. Add the uber_shared package as a dependency in each Flutter app"
echo "3. Run each service and app as described in the README files"