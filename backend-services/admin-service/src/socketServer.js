const socketIO = require('socket.io');
const jwt = require('jsonwebtoken');
const { JWT_SECRET } = require('./config/env');

// Store connected clients
const connectedClients = new Map();

// Initialize Socket.IO server
function initializeSocketServer(server) {
  const io = socketIO(server, {
    cors: {
      origin: "*", // Allow all origins in development
      methods: ["GET", "POST"]
    }
  });

  // Middleware to authenticate socket connections
  io.use((socket, next) => {
    const token = socket.handshake.auth.token || socket.handshake.headers.authorization?.split(' ')[1];
    
    if (!token) {
      return next(new Error('Authentication error: No token provided'));
    }

    jwt.verify(token, JWT_SECRET, (err, decoded) => {
      if (err) {
        return next(new Error('Authentication error: Invalid token'));
      }
      
      socket.userId = decoded.id;
      socket.userRole = decoded.role;
      next();
    });
  });

  // Handle socket connections
  io.on('connection', (socket) => {
    console.log(`👑 Admin ${socket.userId} connected with role ${socket.userRole}`);
    
    // Store connected client
    connectedClients.set(socket.userId, {
      socketId: socket.id,
      userId: socket.userId,
      userRole: socket.userRole,
      connectedAt: new Date()
    });

    // Handle ride status updates
    socket.on('ride_status_update', (data) => {
      console.log(`🚗 Ride status update from admin ${socket.userId}:`, data);
      
      // Broadcast to all connected clients
      socket.broadcast.emit('ride_status_updated', {
        ...data,
        updatedBy: socket.userId,
        updatedAt: new Date()
      });
    });

    // Handle location updates
    socket.on('location_update', (data) => {
      console.log(`📍 Location update from admin ${socket.userId}:`, data);
      
      // Broadcast to all connected clients
      socket.broadcast.emit('location_updated', {
        ...data,
        updatedBy: socket.userId,
        updatedAt: new Date()
      });
    });

    // Handle system monitoring events
    socket.on('monitoring_event', (data) => {
      console.log(`📊 Monitoring event from admin ${socket.userId}:`, data);
      
      // Broadcast to all other admins
      socket.broadcast.emit('system_monitoring_update', {
        ...data,
        reportedBy: socket.userId,
        reportedAt: new Date()
      });
    });

    // Handle disconnection
    socket.on('disconnect', () => {
      console.log(`📴 Admin ${socket.userId} disconnected`);
      connectedClients.delete(socket.userId);
    });

    // Handle error
    socket.on('error', (err) => {
      console.error(`❌ Socket error for admin ${socket.userId}:`, err);
    });
    
    // Handle chat messages monitoring (admins can monitor chat activity)
    socket.on('send_message', (data) => {
      console.log(`💬 Message from user ${socket.userId}:`, data);
      
      // Broadcast to other admins for monitoring purposes
      socket.broadcast.emit('message_activity', {
        ...data,
        userId: socket.userId,
        timestamp: new Date()
      });
    });
  });

  // Function to emit events to specific users
  function emitToUser(userId, event, data) {
    const client = connectedClients.get(userId);
    if (client) {
      io.to(client.socketId).emit(event, data);
    }
  }

  // Function to broadcast events to all connected clients
  function broadcastEvent(event, data) {
    io.emit(event, data);
  }

  // Function to get connected clients count
  function getConnectedClientsCount() {
    return connectedClients.size;
  }

  return {
    io,
    emitToUser,
    broadcastEvent,
    getConnectedClientsCount
  };
}

module.exports = { initializeSocketServer, connectedClients };