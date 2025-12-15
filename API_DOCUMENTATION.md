# Uber Clone API Documentation

This document provides comprehensive documentation for the Uber Clone RESTful API, covering all endpoints, request/response formats, authentication requirements, and error handling.

## 📋 Table of Contents

1. [Authentication](#authentication)
2. [Rider Service API](#rider-service-api)
3. [Driver Service API](#driver-service-api)
4. [Admin Service API](#admin-service-api)
5. [WebSocket API](#websocket-api)
6. [Error Handling](#error-handling)
7. [Rate Limiting](#rate-limiting)

## 🔐 Authentication

### Authentication Flow

All API endpoints (except demo login) require authentication using JWT tokens.

#### Demo Login (Development Only)
```http
POST /api/auth/demo/login/rider
```

**Response:**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "demo-rider",
    "email": "rider@uber.com",
    "firstName": "Demo",
    "lastName": "Rider",
    "role": "rider"
  }
}
```

#### Using Authentication Tokens
Include the JWT token in the Authorization header:
```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## 🚕 Rider Service API

Base URL: `http://localhost:3010/api`

### Rides

#### Create a New Ride
```http
POST /rides
```

**Headers:**
```http
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "pickupAddress": "123 Main St",
  "dropoffAddress": "456 Oak Ave",
  "pickupLatitude": 36.752887,
  "pickupLongitude": 3.042048,
  "dropoffLatitude": 36.753887,
  "dropoffLongitude": 3.043048,
  "estimatedFare": 15.50
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "uuid-string",
    "riderId": "user-id",
    "driverId": null,
    "pickupAddress": "123 Main St",
    "dropoffAddress": "456 Oak Ave",
    "pickupLocation": {
      "lat": 36.752887,
      "lng": 3.042048
    },
    "dropoffLocation": {
      "lat": 36.753887,
      "lng": 3.043048
    },
    "status": "requested",
    "estimatedFare": 15.50,
    "actualFare": null,
    "requestedAt": "2023-12-01T10:00:00Z",
    "acceptedAt": null,
    "startedAt": null,
    "completedAt": null,
    "cancelledAt": null
  }
}
```

#### Get All Rides for User
```http
GET /rides
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid-string",
      "riderId": "user-id",
      "driverId": "driver-id",
      "pickupAddress": "123 Main St",
      "dropoffAddress": "456 Oak Ave",
      "status": "completed",
      "estimatedFare": 15.50,
      "actualFare": 16.25,
      "requestedAt": "2023-12-01T10:00:00Z",
      "acceptedAt": "2023-12-01T10:05:00Z",
      "startedAt": "2023-12-01T10:10:00Z",
      "completedAt": "2023-12-01T10:25:00Z"
    }
  ]
}
```

#### Get Specific Ride
```http
GET /rides/:id
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "uuid-string",
    "riderId": "user-id",
    "driverId": "driver-id",
    "pickupAddress": "123 Main St",
    "dropoffAddress": "456 Oak Ave",
    "pickupLocation": {
      "lat": 36.752887,
      "lng": 3.042048
    },
    "dropoffLocation": {
      "lat": 36.753887,
      "lng": 3.043048
    },
    "status": "completed",
    "estimatedFare": 15.50,
    "actualFare": 16.25,
    "requestedAt": "2023-12-01T10:00:00Z",
    "acceptedAt": "2023-12-01T10:05:00Z",
    "startedAt": "2023-12-01T10:10:00Z",
    "completedAt": "2023-12-01T10:25:00Z"
  }
}
```

#### Cancel Ride
```http
POST /rides/:id/cancel
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "uuid-string",
    "status": "cancelled",
    "cancelledAt": "2023-12-01T10:03:00Z"
  }
}
```

### Messages

#### Send Message
```http
POST /messages
```

**Request Body:**
```json
{
  "rideId": "ride-uuid",
  "recipientId": "recipient-uuid",
  "content": "Hello, when will you arrive?"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "message-uuid",
    "rideId": "ride-uuid",
    "senderId": "sender-uuid",
    "recipientId": "recipient-uuid",
    "content": "Hello, when will you arrive?",
    "createdAt": "2023-12-01T10:15:00Z"
  }
}
```

#### Get Ride Messages
```http
GET /messages/ride/:rideId
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "message-uuid",
      "rideId": "ride-uuid",
      "senderId": "sender-uuid",
      "recipientId": "recipient-uuid",
      "content": "Hello, when will you arrive?",
      "createdAt": "2023-12-01T10:15:00Z"
    }
  ]
}
```

## 🚗 Driver Service API

Base URL: `http://localhost:3020/api`

### Rides

#### Get Available Rides
```http
GET /rides/available
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid-string",
      "riderId": "user-id",
      "pickupAddress": "123 Main St",
      "dropoffAddress": "456 Oak Ave",
      "pickupLocation": {
        "lat": 36.752887,
        "lng": 3.042048
      },
      "dropoffLocation": {
        "lat": 36.753887,
        "lng": 3.043048
      },
      "estimatedFare": 15.50,
      "requestedAt": "2023-12-01T10:00:00Z"
    }
  ]
}
```

#### Accept Ride
```http
POST /rides/:id/accept
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "uuid-string",
    "driverId": "driver-id",
    "status": "accepted",
    "acceptedAt": "2023-12-01T10:05:00Z"
  }
}
```

#### Start Ride
```http
POST /rides/:id/start
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "uuid-string",
    "status": "ongoing",
    "startedAt": "2023-12-01T10:10:00Z"
  }
}
```

#### Complete Ride
```http
POST /rides/:id/complete
```

**Request Body:**
```json
{
  "actualFare": 16.25
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "uuid-string",
    "status": "completed",
    "actualFare": 16.25,
    "completedAt": "2023-12-01T10:25:00Z"
  }
}
```

## 👨‍💼 Admin Service API

Base URL: `http://localhost:3030/api`

### Users

#### Get All Users
```http
GET /users
```

**Query Parameters:**
- `role`: Filter by user role (rider, driver, admin)
- `page`: Page number for pagination
- `limit`: Number of results per page

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "user-uuid",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "rider",
      "phoneNumber": "+1234567890",
      "isVerified": true,
      "createdAt": "2023-12-01T10:00:00Z"
    }
  ],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalUsers": 50,
    "perPage": 10
  }
}
```

#### Get User Details
```http
GET /users/:id
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "user-uuid",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "role": "rider",
    "phoneNumber": "+1234567890",
    "isVerified": true,
    "profilePictureUrl": "https://example.com/profile.jpg",
    "createdAt": "2023-12-01T10:00:00Z",
    "updatedAt": "2023-12-01T10:00:00Z"
  }
}
```

### Rides

#### Get All Rides
```http
GET /rides
```

**Query Parameters:**
- `status`: Filter by ride status
- `driverId`: Filter by driver ID
- `riderId`: Filter by rider ID
- `startDate`: Filter rides after this date
- `endDate`: Filter rides before this date
- `page`: Page number for pagination
- `limit`: Number of results per page

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "ride-uuid",
      "riderId": "rider-uuid",
      "driverId": "driver-uuid",
      "pickupAddress": "123 Main St",
      "dropoffAddress": "456 Oak Ave",
      "status": "completed",
      "estimatedFare": 15.50,
      "actualFare": 16.25,
      "requestedAt": "2023-12-01T10:00:00Z",
      "acceptedAt": "2023-12-01T10:05:00Z",
      "startedAt": "2023-12-01T10:10:00Z",
      "completedAt": "2023-12-01T10:25:00Z"
    }
  ],
  "pagination": {
    "currentPage": 1,
    "totalPages": 3,
    "totalRides": 30,
    "perPage": 10
  }
}
```

#### Get Ride Statistics
```http
GET /rides/stats
```

**Query Parameters:**
- `period`: Time period (day, week, month, year)
- `startDate`: Custom start date
- `endDate`: Custom end date

**Response:**
```json
{
  "success": true,
  "data": {
    "totalRides": 150,
    "completedRides": 140,
    "cancelledRides": 10,
    "totalRevenue": 2345.75,
    "averageFare": 16.75,
    "ridesByStatus": {
      "requested": 5,
      "accepted": 3,
      "ongoing": 2,
      "completed": 140,
      "cancelled": 10
    },
    "ridesByPeriod": [
      {
        "date": "2023-12-01",
        "count": 25,
        "revenue": 412.50
      }
    ]
  }
}
```

## 📡 WebSocket API

The Uber Clone application uses Socket.IO for real-time communication.

### Connection
Connect to: `http://localhost:3000` (port varies by service)

### Events

#### Ride Status Updates
**Listen for:**
```javascript
socket.on('ride_status_updated', (data) => {
  console.log('Ride status updated:', data);
});
```

**Data Structure:**
```json
{
  "rideId": "uuid-string",
  "status": "accepted",
  "timestamp": "2023-12-01T10:05:00Z",
  "driverId": "driver-uuid"
}
```

#### Location Updates
**Listen for:**
```javascript
socket.on('location_updated', (data) => {
  console.log('Location updated:', data);
});
```

**Data Structure:**
```json
{
  "userId": "user-uuid",
  "latitude": 36.752887,
  "longitude": 3.042048,
  "timestamp": "2023-12-01T10:15:00Z"
}
```

#### New Ride Requests
**Listen for:**
```javascript
socket.on('new_ride_request', (data) => {
  console.log('New ride request:', data);
});
```

**Data Structure:**
```json
{
  "rideId": "uuid-string",
  "riderId": "rider-uuid",
  "pickupAddress": "123 Main St",
  "dropoffAddress": "456 Oak Ave",
  "pickupLocation": {
    "lat": 36.752887,
    "lng": 3.042048
  },
  "estimatedFare": 15.50,
  "requestedAt": "2023-12-01T10:00:00Z"
}
```

#### Messages
**Listen for:**
```javascript
socket.on('new_message', (data) => {
  console.log('New message:', data);
});
```

**Data Structure:**
```json
{
  "id": "message-uuid",
  "rideId": "ride-uuid",
  "senderId": "sender-uuid",
  "content": "Hello!",
  "createdAt": "2023-12-01T10:15:00Z"
}
```

### Emitting Events

#### Update Location
```javascript
socket.emit('update_location', {
  latitude: 36.752887,
  longitude: 3.042048
});
```

#### Send Message
```javascript
socket.emit('send_message', {
  rideId: "ride-uuid",
  content: "Hello, when will you arrive?"
});
```

## ⚠️ Error Handling

All API responses follow a consistent error format:

```json
{
  "success": false,
  "message": "Error description",
  "error": "Detailed error information (development only)"
}
```

### HTTP Status Codes

| Code | Description |
|------|-------------|
| 200 | Success |
| 400 | Bad Request - Invalid input data |
| 401 | Unauthorized - Missing or invalid authentication |
| 403 | Forbidden - Insufficient permissions |
| 404 | Not Found - Resource doesn't exist |
| 429 | Too Many Requests - Rate limit exceeded |
| 500 | Internal Server Error - Unexpected server error |

### Common Error Responses

#### Validation Errors
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "type": "field",
      "value": "",
      "msg": "Pickup address is required",
      "path": "pickupAddress",
      "location": "body"
    }
  ]
}
```

#### Authentication Errors
```json
{
  "success": false,
  "message": "Access denied. No token provided."
}
```

## 🚦 Rate Limiting

### Limits

- **General API Requests**: 100 requests per 15 minutes
- **Authentication Requests**: 5 requests per 15 minutes

### Rate Limit Response
```json
{
  "success": false,
  "message": "Too many requests from this IP, please try again later."
}
```

### Headers
Rate limiting information is provided in response headers:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 99
X-RateLimit-Reset: 1512124800
```

---

*This API documentation provides a comprehensive guide to integrating with the Uber Clone application. For additional support, please contact the development team.*