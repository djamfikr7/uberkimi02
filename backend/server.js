const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const http = require('http');
const socketIo = require('socket.io');
const { sequelize } = require('./models');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const rideRoutes = require('./routes/rideRoutes');
const driverRoutes = require('./routes/driverRoutes');
const adminRoutes = require('./routes/adminRoutes');
const { errorHandler } = require('./utils/errorHandler');

// Initialize Express app
const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});

// Middleware
app.use(cors());
app.use(helmet());
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Database connection with retry logic
let isDatabaseConnected = false;
let reconnectAttempts = 0;
const maxReconnectAttempts = 10;

const connectToDatabase = async () => {
  const maxRetries = 5;
  const retryDelay = 5000;

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      console.log(`🔄 Attempting database connection (attempt ${attempt}/${maxRetries})...`);
      await sequelize.authenticate();
      console.log('✅ PostgreSQL database connected successfully');

      // Sync models with database
      await sequelize.sync({ alter: true });
      console.log('✅ Database models synchronized');

      isDatabaseConnected = true;
      reconnectAttempts = 0;
      return true;
    } catch (err) {
      console.error(`❌ Database connection attempt ${attempt} failed:`, err.message);

      if (attempt < maxRetries) {
        console.log(`🔄 Retrying in ${retryDelay / 1000} seconds...`);
        await new Promise(resolve => setTimeout(resolve, retryDelay));
      } else {
        console.log('ℹ️ All connection attempts failed. Falling back to mock data mode');
        isDatabaseConnected = false;
        return false;
      }
    }
  }
};

// Automatic reconnection logic
const setupDatabaseReconnection = () => {
  // Set up connection error handling using sequelize events
  sequelize.addHook('afterConnect', () => {
    isDatabaseConnected = true;
    reconnectAttempts = 0;
    console.log('✅ Database reconnected successfully');
  });

  sequelize.addHook('afterDisconnect', () => {
    isDatabaseConnected = false;
  });

  // Set up error event listener
  const originalErrorHandler = sequelize.options.dialect.constructor.prototype.handleError;
  sequelize.options.dialect.constructor.prototype.handleError = function(error) {
    console.error('❌ Database connection error:', error.message);
    isDatabaseConnected = false;

    if (reconnectAttempts < maxReconnectAttempts) {
      reconnectAttempts++;
      console.log(`🔄 Attempting to reconnect to database (attempt ${reconnectAttempts}/${maxReconnectAttempts})...`);

      setTimeout(async () => {
        try {
          await sequelize.authenticate();
          console.log('✅ Database reconnected successfully');
          isDatabaseConnected = true;
          reconnectAttempts = 0;
        } catch (err) {
          console.error('❌ Database reconnection failed:', err.message);
        }
      }, 5000);
    } else {
      console.log('ℹ️ Max reconnection attempts reached. Using mock data mode');
    }

    if (originalErrorHandler) {
      originalErrorHandler.call(this, error);
    }
  };
};

// Try to connect to database, fall back to mock mode if failed
const startServer = async () => {
  const isDatabaseConnected = await connectToDatabase();

  // Start server
  const PORT = process.env.PORT || 3000;
  server.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`🌐 API available at http://localhost:${PORT}/api`);
    console.log('🔄 Socket.io connected and ready');
    if (!isDatabaseConnected) {
      console.log('ℹ️ Using mock data - database connection failed');
    }
  });
};

// Start the server
startServer();

// Setup database reconnection
setupDatabaseReconnection();

// Socket.io connection
io.on('connection', (socket) => {
  console.log('� New client connected:', socket.id);

  socket.on('disconnect', () => {
    console.log('�🔴 Client disconnected:', socket.id);
  });

  // Ride status updates
  socket.on('ride_status_update', (data) => {
    console.log('🚗 Ride status update:', data);
    io.emit('ride_status_updated', data);
  });

  // Location updates
  socket.on('location_update', (data) => {
    console.log('📍 Location update:', data);
    io.emit('location_updated', data);
  });
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/rides', rideRoutes);
app.use('/api/drivers', driverRoutes);
app.use('/api/admin', adminRoutes);

// Health check endpoint
app.get('/api/health', async (req, res) => {
  try {
    // Test database connection
    const dbStatus = await sequelize.authenticate()
      .then(() => 'connected')
      .catch(() => 'disconnected');

    res.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      services: {
        database: dbStatus,
        socket: 'connected',
        auth: 'operational',
        rides: 'operational',
        drivers: 'operational'
      },
      environment: process.env.NODE_ENV || 'development',
      version: '1.0.0'
    });
  } catch (error) {
    console.error('Health check error:', error);
    res.status(500).json({
      status: 'unhealthy',
      error: error.message
    });
  }
});

// Error handling middleware
app.use(errorHandler);

// 404 handler
app.use((req, res, next) => {
  res.status(404).json({
    error: 'NOT_FOUND',
    message: 'Endpoint not found'
  });
});


module.exports = { app, server, io };
