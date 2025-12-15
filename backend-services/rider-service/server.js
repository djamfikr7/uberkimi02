const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const path = require('path');
const http = require('http'); // Add this for Socket.IO
const rateLimit = require('express-rate-limit');
const helmet = require('helmet');

// Load environment variables
dotenv.config();

// Create Express app
const app = express();
const PORT = process.env.PORT || 3010;

// Create HTTP server for Socket.IO
const server = http.createServer(app); // Changed from app.listen to createServer

// Security middleware
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "https:"],
      scriptSrc: ["'self'"],
      connectSrc: ["'self'", "ws:", "wss:"],
    },
  },
}));

app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000'],
  credentials: true
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: {
    success: false,
    message: 'Too many requests from this IP, please try again later.'
  }
});
app.use(limiter);

// API-specific rate limiting for auth endpoints
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // limit each IP to 5 requests per windowMs for auth
  message: {
    success: false,
    message: 'Too many authentication attempts, please try again later.'
  }
});

// Apply auth rate limiting to auth routes
app.use('/api/auth', authLimiter);

// Body parsing middleware with security options
app.use(express.json({ 
  strict: false,
  limit: '10mb'
}));
app.use(express.urlencoded({ 
  extended: true,
  limit: '10mb'
}));

// Routes
app.get('/', (req, res) => {
  res.json({ 
    message: 'Rider Service API', 
    version: '1.0.0',
    status: 'running'
  });
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'rider-service'
  });
});

// Demo login endpoint for development
app.post('/api/auth/demo/login/rider', (req, res) => {
  // In development mode, bypass authentication
  if (process.env.NODE_ENV === 'development') {
    const demoToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImRlbW8tcmlkZXIiLCJlbWFpbCI6InJpZGVyQHV1YmVyLmNvbSIsInJvbGUiOiJyaWRlciIsImlhdCI6MTUxNjIzOTAyMn0.6FxA7Xf7ER3WvCd8fFcKx0X1iC5UN8q9rJcXD1Mqj4Y';
    res.json({
      success: true,
      token: demoToken,
      user: {
        id: 'demo-rider',
        email: 'rider@uber.com',
        firstName: 'Demo',
        lastName: 'Rider',
        role: 'rider'
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
  console.log(`Rider Service running on port ${PORT}`);
  console.log(`Socket.IO server initialized with ${socketServer.getConnectedClientsCount()} connected clients`);
});

module.exports = app;