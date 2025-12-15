# Admin Service

The Admin Service is a backend microservice for the Uber Clone project that handles all administrative functionality.

## Features

- Admin authentication and profile management
- User management (rider and driver accounts)
- Ride monitoring and management
- Analytics and reporting
- System configuration and settings

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
2. Navigate to the admin-service directory:
   ```bash
   cd backend-services/admin-service
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
- `POST /api/auth/register` - Register new admin
- `POST /api/auth/login` - Admin login
- `POST /api/auth/demo/login/admin` - Demo login for development

### User Management
- `GET /api/users` - Get all users
- `GET /api/users/:id/:role` - Get specific user
- `PUT /api/users/:id/status` - Update user status

### Ride Management
- `GET /api/rides` - Get all rides
- `GET /api/rides/:id` - Get specific ride
- `PUT /api/rides/:id/status` - Update ride status

### Analytics
- `GET /api/analytics/dashboard` - Get dashboard statistics
- `GET /api/analytics/rides` - Get ride analytics
- `GET /api/analytics/growth` - Get user growth data

## Environment Variables

Create a `.env` file with the following variables:

```
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=uber_clone_admin
DB_USER=uber_user
DB_PASSWORD=uber_password

# JWT Configuration
JWT_SECRET=uber_clone_secret_key_for_development_only
JWT_EXPIRES_IN=24h

# Server Configuration
PORT=3030
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