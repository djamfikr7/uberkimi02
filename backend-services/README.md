# Backend Services

This directory contains all the backend microservices for the Uber Clone project.

## Services

1. **[Rider Service](./rider-service)** - Handles all rider-related functionality
2. **[Driver Service](./driver-service)** - Handles all driver-related functionality
3. **[Admin Service](./admin-service)** - Handles all administrative functionality
4. **[Shared Utils](./shared-utils)** - Shared utilities and models used across all services

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

1. Navigate to each service directory and install dependencies:
   ```bash
   cd rider-service && npm install
   cd ../driver-service && npm install
   cd ../admin-service && npm install
   cd ../shared-utils && npm install
   ```

2. Set up environment variables for each service (see `.env.example` in each service directory)

3. Start each service:
   ```bash
   cd rider-service && npm start
   cd ../driver-service && npm start
   cd ../admin-service && npm start
   ```

### Development

For development with auto-reload:
```bash
npm run dev
```

## Shared Utilities

The shared utilities package contains common functionality used across all services:

- JWT utilities for token generation and validation
- Password utilities for hashing and comparison
- Validation utilities for email, phone, and password
- Location utilities for distance calculation
- Shared data models (User, Vehicle, Ride)

To use the shared utilities in any service:
```javascript
const { jwtUtils, passwordUtils, validationUtils, locationUtils, User, Vehicle, Ride } = require('@uber-clone/shared-utils');
```

## API Documentation

Each service has its own API documentation in its respective README.md file:

- [Rider Service API](./rider-service/README.md)
- [Driver Service API](./driver-service/README.md)
- [Admin Service API](./admin-service/README.md)

## Environment Variables

Each service requires its own environment variables. See the `.env.example` file in each service directory for the required variables.

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for contribution guidelines.

## License

See [LICENSE](../LICENSE) for license information.