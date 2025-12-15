const io = require('socket.io-client');
const jwt = require('jsonwebtoken');

// Create a test JWT token
const createTestToken = (userId, role) => {
  return jwt.sign(
    { id: userId, role: role },
    'uber_clone_secret_key_for_development_only',
    { expiresIn: '1h' }
  );
};

// Test Socket.IO connections and events
const testSocketIO = async () => {
  console.log('🧪 Starting comprehensive Socket.IO integration tests...\n');

  // Create test tokens
  const riderToken = createTestToken('demo-rider', 'rider');
  const driverToken = createTestToken('demo-driver', 'driver');
  const adminToken = createTestToken('demo-admin', 'admin');

  // Track received events
  let eventsReceived = 0;
  const expectedEvents = 6; // We expect 6 events to be received

  // Connect to rider service
  console.log('🔌 Connecting to Rider Service Socket.IO...');
  const riderSocket = io('http://localhost:3010', {
    auth: { token: riderToken }
  });

  riderSocket.on('connect', () => {
    console.log('✅ Rider connected successfully');
  });

  riderSocket.on('connect_error', (error) => {
    console.log('❌ Rider connection error:', error.message);
  });

  riderSocket.on('ride_status_updated', (data) => {
    console.log('🚗 Rider received ride status update:', data);
    eventsReceived++;
  });

  riderSocket.on('location_updated', (data) => {
    console.log('📍 Rider received location update:', data);
    eventsReceived++;
  });

  // Connect to driver service
  console.log('\n🔌 Connecting to Driver Service Socket.IO...');
  const driverSocket = io('http://localhost:3020', {
    auth: { token: driverToken }
  });

  driverSocket.on('connect', () => {
    console.log('✅ Driver connected successfully');
  });

  driverSocket.on('connect_error', (error) => {
    console.log('❌ Driver connection error:', error.message);
  });

  driverSocket.on('new_ride_request', (data) => {
    console.log('🔔 Driver received new ride request:', data);
    eventsReceived++;
  });

  driverSocket.on('ride_status_updated', (data) => {
    console.log('🚗 Driver received ride status update:', data);
    eventsReceived++;
  });

  driverSocket.on('location_updated', (data) => {
    console.log('📍 Driver received location update:', data);
    eventsReceived++;
  });

  // Connect to admin service
  console.log('\n🔌 Connecting to Admin Service Socket.IO...');
  const adminSocket = io('http://localhost:3030', {
    auth: { token: adminToken }
  });

  adminSocket.on('connect', () => {
    console.log('✅ Admin connected successfully');
  });

  adminSocket.on('connect_error', (error) => {
    console.log('❌ Admin connection error:', error.message);
  });

  adminSocket.on('ride_status_updated', (data) => {
    console.log('🚗 Admin received ride status update:', data);
    eventsReceived++;
  });

  adminSocket.on('location_updated', (data) => {
    console.log('📍 Admin received location update:', data);
  });

  adminSocket.on('new_ride_request_created', (data) => {
    console.log('🔔 Admin received new ride request notification:', data);
  });

  // Wait for connections to establish
  await new Promise(resolve => setTimeout(resolve, 2000));

  // Test emitting events
  console.log('\n📤 Testing event emissions...');

  // Rider emits location update
  console.log('\n📍 Rider emitting location update...');
  riderSocket.emit('location_update', {
    userId: 'demo-rider',
    userType: 'rider',
    latitude: 40.7128,
    longitude: -74.0060,
    timestamp: new Date().toISOString(),
    rideId: 'test-ride-1'
  });

  // Driver emits ride status update
  console.log('\n🚗 Driver emitting ride status update...');
  driverSocket.emit('ride_status_update', {
    rideId: 'test-ride-1',
    status: 'accepted',
    driverId: 'demo-driver',
    timestamp: new Date().toISOString()
  });

  // Admin emits monitoring event
  console.log('\n📊 Admin emitting monitoring event...');
  adminSocket.emit('monitoring_event', {
    eventType: 'test_event',
    message: 'Testing Socket.IO integration',
    timestamp: new Date().toISOString()
  });

  // Wait for events to be processed
  await new Promise(resolve => setTimeout(resolve, 3000));

  // Summary
  console.log(`\n📈 Test Summary:`);
  console.log(`   Expected events: ${expectedEvents}`);
  console.log(`   Received events: ${eventsReceived}`);
  console.log(`   Success rate: ${Math.round((eventsReceived / expectedEvents) * 100)}%`);

  if (eventsReceived >= expectedEvents) {
    console.log('\n🎉 All Socket.IO integration tests passed!');
  } else {
    console.log('\n⚠️  Some events were not received. Check the implementation.');
  }

  // Disconnect all sockets
  console.log('\n🔚 Disconnecting all sockets...');
  riderSocket.disconnect();
  driverSocket.disconnect();
  adminSocket.disconnect();

  console.log('\n✅ Comprehensive Socket.IO integration tests completed!');
};

// Run the tests
testSocketIO().catch(console.error);