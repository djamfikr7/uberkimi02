const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const path = require('path');
const http = require('http'); // Add this for Socket.IO

// Load environment variables
dotenv.config();

// Create Express app
const app = express();
const PORT = process.env.PORT || 3020;

// Create HTTP server for Socket.IO
const server = http.createServer(app); // Changed from app.listen to createServer

// Middleware
app.use(cors());
app.use(express.json({ strict: false }));
app.use(express.urlencoded({ extended: true }));

// Routes
app.get('/', (req, res) => {
  res.json({ 
    message: 'Driver Service API', 
    version: '1.0.0',
    status: 'running'
  });
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'driver-service'
  });
});

// Demo login endpoint for development
app.post('/api/auth/demo/login/driver', (req, res) => {
  // In development mode, bypass authentication
  if (process.env.NODE_ENV === 'development') {
    const demoToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRlbW8tZHJpdmVyIiwiZW1haWwiOiJkcml2ZXJAdXViZXIuY29tIiwicm9sZSI6ImRyaXZlciIsImlhdCI6MTUxNjIzOTAyMn0.6FxA7Xf7ER3WvCd8fFcKx0X1iC5UN8q9rJcXD1Mqj4Y';
    res.json({
      success: true,
      token: demoToken,
      user: {
        id: 'demo-driver',
        email: 'driver@uber.com',
        firstName: 'Demo',
        lastName: 'Driver',
        role: 'driver'
      }
    });
  } else {
    res.status(403).json({ 
      success: false, 
      message: 'Demo login only available in development mode' 
    });
  }
});

// API routes
app.use('/api/auth', require('./src/routes/authRoutes'));
app.use('/api/users', require('./src/routes/userRoutes'));
app.use('/api/rides', require('./src/routes/rideRoutes'));
app.use('/api/location', require('./src/routes/locationRoutes')); // Add location routes
app.use('/api/messages', require('./src/routes/messageRoutes')); // Add message routes

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    success: false, 
    message: 'Something went wrong!',
    error: process.env.NODE_ENV === 'development' ? err.message : {}
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ 
    success: false, 
    message: 'Route not found' 
  });
});

// Initialize Socket.IO server
const { initializeSocketServer } = require('./src/socketServer');
const socketServer = initializeSocketServer(server);

// Make socket server available to routes
app.set('socketServer', socketServer);

// Start server
server.listen(PORT, () => { // Changed from app.listen to server.listen
  console.log(`Driver Service running on port ${PORT}`);
  console.log(`Socket.IO server initialized with ${socketServer.getConnectedClientsCount()} connected clients`);
});

module.exports = app;