# Uber Clone - Separated Apps Architecture

This project implements a ride-sharing platform with three separated applications:

## Project Structure

```
uberkimi02/
├── flutter-apps/
│   ├── rider_app/          # Rider application
│   ├── driver_app/         # Driver application
│   └── admin_app/          # Admin application
├── flutter-packages/
│   └── uber_shared/        # Shared components and utilities
├── backend-services/
│   ├── rider-service/      # Rider backend service
│   ├── driver-service/     # Driver backend service
│   └── admin-service/      # Admin backend service
└── init-scripts/           # Initialization scripts
```

## Applications

### Rider App
- Request rides
- Track driver location in real-time
- View ride progress
- Rate drivers
- Cash payment processing

### Driver App
- Receive ride notifications
- Accept/decline ride requests
- Navigate to pickup location
- Track ride progress
- Collect cash payments
- Update ride status

### Admin App
- Monitor all rides in real-time
- Manage users (riders and drivers)
- View system health and statistics
- Handle disputes and complaints

## Technology Stack

- **Frontend**: Flutter 3.10.4+ with Dart 3.0.0+
- **Backend**: Node.js with Express.js
- **Database**: PostgreSQL
- **Real-time Communication**: Socket.IO
- **Maps**: Google Maps with fallback to OpenStreetMap
- **Authentication**: JWT with demo mode for development

## Getting Started

### Prerequisites
- Flutter SDK 3.10.4+
- Dart 3.0.0+
- Node.js
- PostgreSQL

### Backend Setup
1. Navigate to each service directory:
   ```bash
   cd backend-services/rider-service
   npm install
   ```
2. Configure environment variables in `.env` files
3. Start each service:
   ```bash
   npm start
   ```

### Frontend Setup
1. Navigate to each app directory:
   ```bash
   cd flutter-apps/rider_app
   flutter pub get
   ```
2. Run the apps:
   ```bash
   flutter run -d chrome
   ```

## Environment Configuration

Each app and service uses environment variables for configuration:
- API endpoints
- Map provider keys
- Database connections
- Authentication settings

## Development Mode

Authentication can be bypassed in development mode using demo endpoints:
- Rider: `POST /api/auth/demo/login/rider`
- Driver: `POST /api/auth/demo/login/driver`
- Admin: `POST /api/auth/demo/login/admin`

## Features Implemented

- ✅ Real-time ride request/notification system
- ✅ Live location tracking between rider and driver
- ✅ Cash-only payment processing
- ✅ Ride lifecycle management (requested → accepted → in_progress → completed)
- ✅ Cancellation policies and fraud detection
- ✅ Map provider fallback mechanism
- ✅ Admin monitoring dashboard