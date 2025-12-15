# Driver Service

The Driver Service is a backend microservice for the Uber Clone project that handles all driver-related functionality.

## Features

- Driver authentication and profile management
- Vehicle information management
- Available ride listing and acceptance
- Ride progress tracking (pickup, start, complete)
- Earnings tracking and reporting

## Technology Stack

- **Node.js** with **Express.js**
- **PostgreSQL** with **Sequelize ORM**
- **JWT** for authentication
- **Socket.IO** for real-time communication

## Getting Started

### Prerequisites

- Node.js 16+
- PostgreSQL 13+
- npm or yarn

### Installation

1. Clone the repository
2. Navigate to the driver-service directory:
   ```bash
   cd backend-services/driver-service
   ```
3. Install dependencies:
   ```bash
   npm install
   ```
4. Set up environment variables (see `.env.example`)
5. Start the service:
   ```bash
   npm start
   ```

### Development

For development with auto-reload:
```bash
npm run dev
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new driver
- `POST /api/auth/login` - Driver login
- `POST /api/auth/demo/login/driver` - Demo login for development

### User Management
- `GET /api/users/profile` - Get driver profile
- `PUT /api/users/profile` - Update driver profile

### Ride Management
- `GET /api/rides/available` - Get available rides
- `GET /api/rides/:id` - Get ride details
- `POST /api/rides/:id/accept` - Accept ride
- `POST /api/rides/:id/start` - Start ride
- `POST /api/rides/:id/complete` - Complete ride

## Environment Variables

Create a `.env` file with the following variables:

```
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=uber_clone_driver
DB_USER=uber_user
DB_PASSWORD=uber_password

# JWT Configuration
JWT_SECRET=uber_clone_secret_key_for_development_only
JWT_EXPIRES_IN=24h

# Server Configuration
PORT=3020
NODE_ENV=development

# Map Configuration
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
MAPBOX_ACCESS_TOKEN=your_mapbox_access_token
```

## Development Mode

In development mode, authentication can be bypassed using demo endpoints for faster testing and iteration.

## Contributing

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for contribution guidelines.

## License

See [LICENSE](../../LICENSE) for license information.