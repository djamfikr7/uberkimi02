# Uber Clone Backend Services

This directory contains the refactored backend services for the Uber Clone application, separated by role.

## Services Structure

### Rider Service
Handles all functionality related to riders:
- Rider authentication
- Ride requests and management
- Location services
- Fare calculation
- Ride history

### Driver Service
Handles all functionality related to drivers:
- Driver authentication
- Ride assignment and acceptance
- Earnings tracking
- Availability status
- Vehicle management

### Admin Service
Handles all administrative functionality:
- User management (riders and drivers)
- System analytics and reporting
- Configuration management
- Support ticket handling

## Getting Started

Each service is a standalone Node.js application that can be run independently.

### Prerequisites
- Node.js (v18+ recommended)
- PostgreSQL (v14+ recommended)
- npm or yarn

### Installation
Navigate to each service directory and install dependencies:

```bash
cd rider-service
npm install

cd ../driver-service
npm install

cd ../admin-service
npm install
```

### Configuration
Each service requires its own `.env` file with appropriate configuration.

### Running Services
```bash
# Rider Service
cd rider-service
npm run dev

# Driver Service
cd driver-service
npm run dev

# Admin Service
cd admin-service
npm run dev
```

## Inter-Service Communication
Services communicate with each other through REST APIs and shared database tables where appropriate.

## Database
Each service connects to the same PostgreSQL database but uses different tables or table prefixes based on role.