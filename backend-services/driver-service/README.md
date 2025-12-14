# Uber Clone Backend

A comprehensive backend for the Uber Clone application built with Node.js, Express, and PostgreSQL.

## Features

- **Authentication**: JWT-based authentication with bypass OTP for development
- **User Management**: Rider, Driver, and Admin user types
- **Ride Management**: Complete ride lifecycle management
- **Real-time Updates**: Socket.io for live ride tracking and status updates
- **PostgreSQL Database**: Comprehensive database schema with Sequelize ORM
- **RESTful API**: Well-structured API endpoints
- **Error Handling**: Comprehensive error handling middleware
- **Security**: Helmet, CORS, and input validation

## Prerequisites

- Node.js (v18+ recommended)
- PostgreSQL (v14+ recommended)
- npm or yarn

## Installation

1. Clone the repository
2. Navigate to the backend directory
3. Install dependencies:

```bash
cd backend
npm install
```

## Configuration

Create a `.env` file in the backend directory and configure your environment variables:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=uber_clone
DB_USER=postgres
DB_PASSWORD=postgres

# JWT Configuration
JWT_SECRET=your_very_secure_jwt_secret_here_change_in_production
JWT_EXPIRES_IN=24h

# Server Configuration
PORT=3000
NODE_ENV=development
```

## Database Setup

1. Make sure PostgreSQL is running
2. Create the database:

```sql
CREATE DATABASE uber_clone;
```

3. Run the database setup script (from the root directory):

```bash
psql -U postgres -d uber_clone -f database_setup.sql
```

## Running the Server

### Development

```bash
npm run dev
```

### Production

```bash
npm start
```

The server will start on `http://localhost:3000`

## API Documentation

### Base URL

`http://localhost:3000/api`

### Authentication

- **Login**: `POST /api/auth/login`
- **Register**: `POST /api/auth/register`
- **Get Current User**: `GET /api/auth/me` (Protected)

### Demo Endpoints (for quick testing)

- **Rider Demo Login**: `POST /api/auth/demo/login/rider`
- **Driver Demo Login**: `POST /api/auth/demo/login/driver`
- **Admin Demo Login**: `POST /api/auth/demo/login/admin`

### Health Check

- **Health**: `GET /api/health`

## Authentication

All protected routes require a valid JWT token in the Authorization header:

```
Authorization: Bearer your_jwt_token_here
```

## Socket.io Events

- **Connection**: `connection`
- **Disconnection**: `disconnect`
- **Ride Status Update**: `ride_status_update`
- **Location Update**: `location_update`

## Project Structure

```
backend/
├── config/              # Configuration files
├── controllers/         # Route controllers
├── middleware/          # Express middleware
├── models/              # Database models
├── routes/              # API routes
├── services/            # Business logic services
├── utils/               # Utility functions
├── .env                 # Environment variables
├── package.json         # Node.js dependencies
├── server.js            # Main server file
└── README.md            # This file
```

## Testing

The backend includes demo endpoints for quick testing. You can use these to test the authentication flow without setting up a database.

## Security Notes

- Always change the `JWT_SECRET` in production
- Use HTTPS in production
- Implement proper rate limiting
- Use environment variables for sensitive data
- Regularly update dependencies

## License

This project is licensed under the MIT License.