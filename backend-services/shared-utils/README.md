# Shared Utilities

Shared utilities and models for the Uber Clone project.

## Features

- JWT utilities for token generation and validation
- Password utilities for hashing and comparison
- Validation utilities for email, phone, and password
- Location utilities for distance calculation
- Shared data models (User, Vehicle, Ride)

## Installation

```bash
npm install @uber-clone/shared-utils
```

## Usage

### JWT Utilities

```javascript
const { jwtUtils } = require('@uber-clone/shared-utils');

// Sign a token
const token = jwtUtils.signToken({ userId: 123 }, 'secret', '24h');

// Verify a token
const payload = jwtUtils.verifyToken(token, 'secret');
```

### Password Utilities

```javascript
const { passwordUtils } = require('@uber-clone/shared-utils');

// Hash a password
const hashedPassword = await passwordUtils.hashPassword('myPassword123');

// Compare passwords
const isMatch = await passwordUtils.comparePassword('myPassword123', hashedPassword);
```

### Validation Utilities

```javascript
const { validationUtils } = require('@uber-clone/shared-utils');

// Validate email
const isValidEmail = validationUtils.isValidEmail('user@example.com');

// Validate phone
const isValidPhone = validationUtils.isValidPhone('+1234567890');

// Validate password
const isValidPassword = validationUtils.isValidPassword('MyPassword123');
```

### Location Utilities

```javascript
const { locationUtils } = require('@uber-clone/shared-utils');

// Calculate distance between two points (in kilometers)
const distance = locationUtils.calculateDistance(40.7128, -74.0060, 40.7589, -73.9851);
```

### Models

```javascript
const { User, Vehicle, Ride } = require('@uber-clone/shared-utils');

// Create a user
const user = new User({
  id: 'user-1',
  email: 'user@example.com',
  firstName: 'John',
  lastName: 'Doe',
  phoneNumber: '+1234567890',
  role: 'rider'
});

// Create a vehicle
const vehicle = new Vehicle({
  make: 'Toyota',
  model: 'Camry',
  year: 2020,
  licensePlate: 'ABC123',
  color: 'White'
});

// Create a ride
const ride = new Ride({
  id: 'ride-1',
  riderId: 'rider-1',
  driverId: 'driver-1',
  pickupAddress: '123 Main St',
  dropoffAddress: '456 Oak Ave',
  estimatedFare: 15.50,
  status: 'requested'
});
```

## Contributing

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for contribution guidelines.

## License

See [LICENSE](../../LICENSE) for license information.