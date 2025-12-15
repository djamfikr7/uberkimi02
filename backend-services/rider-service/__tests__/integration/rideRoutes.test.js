const request = require('supertest');
const { app } = require('../../server');

describe('Ride Routes Integration Tests', () => {
  let authToken;
  
  beforeAll(async () => {
    // Get auth token from demo login
    const response = await request(app)
      .post('/api/auth/demo/login/rider')
      .expect(200);
    
    authToken = response.body.data.token;
  });

  test('should create a new ride', async () => {
    const rideData = {
      pickupAddress: '123 Main St',
      dropoffAddress: '456 Oak Ave',
      pickupLatitude: 36.752887,
      pickupLongitude: 3.042048,
      dropoffLatitude: 36.753887,
      dropoffLongitude: 3.043048,
      estimatedFare: 15.50
    };

    const response = await request(app)
      .post('/api/rides')
      .set('Authorization', `Bearer ${authToken}`)
      .send(rideData)
      .expect(201);

    expect(response.body.success).toBe(true);
    expect(response.body.data).toHaveProperty('id');
    expect(response.body.data.pickupAddress).toBe(rideData.pickupAddress);
    expect(response.body.data.dropoffAddress).toBe(rideData.dropoffAddress);
  });

  test('should get all rides for user', async () => {
    const response = await request(app)
      .get('/api/rides')
      .set('Authorization', `Bearer ${authToken}`)
      .expect(200);

    expect(response.body.success).toBe(true);
    expect(Array.isArray(response.body.data)).toBe(true);
  });

  test('should get a specific ride', async () => {
    // First create a ride
    const rideData = {
      pickupAddress: '123 Main St',
      dropoffAddress: '456 Oak Ave',
      pickupLatitude: 36.752887,
      pickupLongitude: 3.042048,
      dropoffLatitude: 36.753887,
      dropoffLongitude: 3.043048,
      estimatedFare: 15.50
    };

    const createResponse = await request(app)
      .post('/api/rides')
      .set('Authorization', `Bearer ${authToken}`)
      .send(rideData)
      .expect(201);

    const rideId = createResponse.body.data.id;

    // Then get the ride
    const response = await request(app)
      .get(`/api/rides/${rideId}`)
      .set('Authorization', `Bearer ${authToken}`)
      .expect(200);

    expect(response.body.success).toBe(true);
    expect(response.body.data.id).toBe(rideId);
    expect(response.body.data.pickupAddress).toBe(rideData.pickupAddress);
  });

  test('should cancel a ride', async () => {
    // First create a ride
    const rideData = {
      pickupAddress: '123 Main St',
      dropoffAddress: '456 Oak Ave',
      pickupLatitude: 36.752887,
      pickupLongitude: 3.042048,
      dropoffLatitude: 36.753887,
      dropoffLongitude: 3.043048,
      estimatedFare: 15.50
    };

    const createResponse = await request(app)
      .post('/api/rides')
      .set('Authorization', `Bearer ${authToken}`)
      .send(rideData)
      .expect(201);

    const rideId = createResponse.body.data.id;

    // Then cancel the ride
    const response = await request(app)
      .post(`/api/rides/${rideId}/cancel`)
      .set('Authorization', `Bearer ${authToken}`)
      .expect(200);

    expect(response.body.success).toBe(true);
    expect(response.body.data.status).toBe('cancelled');
  });

  test('should reject invalid ride data', async () => {
    const invalidRideData = {
      pickupAddress: '', // Invalid - empty
      dropoffAddress: '456 Oak Ave',
      pickupLatitude: 'invalid', // Invalid - not a number
      pickupLongitude: 3.042048,
      dropoffLatitude: 36.753887,
      dropoffLongitude: 3.043048,
      estimatedFare: 15.50
    };

    const response = await request(app)
      .post('/api/rides')
      .set('Authorization', `Bearer ${authToken}`)
      .send(invalidRideData)
      .expect(400);

    expect(response.body.success).toBe(false);
    expect(Array.isArray(response.body.errors)).toBe(true);
  });
});