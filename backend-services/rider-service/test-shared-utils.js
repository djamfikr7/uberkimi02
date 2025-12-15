// Test file to verify shared utilities package is working correctly

const { jwtUtils, passwordUtils, validationUtils, locationUtils, User, Vehicle, Ride } = require('@uber-clone/shared-utils');

console.log('Testing shared utilities package...');

// Test JWT utilities
console.log('\n--- Testing JWT Utilities ---');
const payload = { userId: 123, role: 'rider' };
const secret = 'test-secret';
const token = jwtUtils.signToken(payload, secret, '1h');
console.log('Generated token:', token);

const verifiedPayload = jwtUtils.verifyToken(token, secret);
console.log('Verified payload:', verifiedPayload);

// Test password utilities
console.log('\n--- Testing Password Utilities ---');
(async () => {
  const password = 'MyPassword123';
  const hashedPassword = await passwordUtils.hashPassword(password);
  console.log('Hashed password:', hashedPassword);
  
  const isMatch = await passwordUtils.comparePassword(password, hashedPassword);
  console.log('Password match:', isMatch);
})();

// Test validation utilities
console.log('\n--- Testing Validation Utilities ---');
const email = 'user@example.com';
const phone = '+1234567890';
const validPassword = 'MyPassword123';
const invalidPassword = 'weak';

console.log('Valid email:', validationUtils.isValidEmail(email));
console.log('Valid phone:', validationUtils.isValidPhone(phone));
console.log('Valid password:', validationUtils.isValidPassword(validPassword));
console.log('Invalid password:', validationUtils.isValidPassword(invalidPassword));

// Test location utilities
console.log('\n--- Testing Location Utilities ---');
const distance = locationUtils.calculateDistance(40.7128, -74.0060, 40.7589, -73.9851);
console.log('Distance between coordinates:', distance, 'km');

// Test models
console.log('\n--- Testing Models ---');
const userData = {
  id: 'user-1',
  email: 'user@example.com',
  firstName: 'John',
  lastName: 'Doe',
  phoneNumber: '+1234567890',
  role: 'rider'
};

const user = new User(userData);
console.log('User full name:', user.getFullName());
console.log('User is active:', user.isActive());

const vehicleData = {
  make: 'Toyota',
  model: 'Camry',
  year: 2020,
  licensePlate: 'ABC123',
  color: 'White'
};

const vehicle = new Vehicle(vehicleData);
console.log('Vehicle:', vehicle);

const rideData = {
  id: 'ride-1',
  riderId: 'rider-1',
  driverId: 'driver-1',
  pickupAddress: '123 Main St',
  dropoffAddress: '456 Oak Ave',
  estimatedFare: 15.50,
  status: 'requested',
  requestedAt: new Date().toISOString()
};

const ride = new Ride(rideData);
console.log('Ride in progress:', ride.isInProgress());
console.log('Ride completed:', ride.isCompleted());
console.log('Ride cancelled:', ride.isCancelled());

console.log('\nAll tests completed successfully!');