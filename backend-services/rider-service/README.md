# Rider Service

The Rider Service is a backend microservice for the Uber Clone project that handles all rider-related functionality.

## Features

- User authentication and profile management
- Ride request creation and management
- Ride history and tracking
- Payment processing
- Rating and feedback collection

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
2. Navigate to the rider-service directory:
   ```bash
   cd backend-services/rider-service
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
- `POST /api/auth/register` - Register new rider
- `POST /api/auth/login` - Rider login
- `POST /api/auth/demo/login/rider` - Demo login for development

### User Management
- `GET /api/users/profile` - Get rider profile
- `PUT /api/users/profile` - Update rider profile

### Ride Management
- `POST /api/rides` - Create new ride request
- `GET /api/rides/:id` - Get ride details
- `GET /api/rides` - Get ride history
- `POST /api/rides/:id/cancel` - Cancel ride

## Environment Variables

Create a `.env` file with the following variables:

```
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=uber_clone_rider
DB_USER=uber_user
DB_PASSWORD=uber_password

# JWT Configuration
JWT_SECRET=uber_clone_secret_key_for_development_only
JWT_EXPIRES_IN=24h

# Server Configuration
PORT=3001
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