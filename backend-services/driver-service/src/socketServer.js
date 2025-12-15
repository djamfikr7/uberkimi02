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
    console.log(`🚗 Driver ${socket.userId} connected with role ${socket.userRole}`);
    
    // Store connected client
    connectedClients.set(socket.userId, {
      socketId: socket.id,
      userId: socket.userId,
      userRole: socket.userRole,
      connectedAt: new Date()
    });

    // Handle ride status updates
    socket.on('ride_status_update', (data) => {
      console.log(`🚗 Ride status update from driver ${socket.userId}:`, data);
      
      // Emit to all connected clients
      io.emit('ride_status_updated', {
        ...data,
        updatedBy: socket.userId,
        updatedAt: new Date()
      });
      
      // If this is a ride acceptance, notify the rider
      if (data.status === 'accepted' && data.riderId) {
        emitToUser(data.riderId, 'ride_accepted', {
          rideId: data.rideId,
          driverId: socket.userId,
          acceptedAt: new Date()
        });
      }
    });

    // Handle location updates
    socket.on('location_update', (data) => {
      console.log(`📍 Location update from driver ${socket.userId}:`, data);
      
      // Emit to all connected clients
      io.emit('location_updated', {
        ...data,
        updatedBy: socket.userId,
        updatedAt: new Date()
      });
      
      // Notify rider if this is a ride in progress
      if (data.rideId) {
        // In a real implementation, we would look up the rider for this ride
        // For now, we'll broadcast to all connected riders
        io.emit('driver_location_updated', {
          ...data,
          driverId: socket.userId
        });
      }
    });

    // Handle new ride requests (drivers can emit these when they want to simulate a new request)
    socket.on('new_ride_request', (data) => {
      console.log(`🔔 New ride request from driver ${socket.userId}:`, data);
      
      // Emit to all connected clients
      io.emit('new_ride_request_created', {
        ...data,
        requestedBy: socket.userId,
        requestedAt: new Date()
      });
    });

    // Handle disconnection
    socket.on('disconnect', () => {
      console.log(`📴 Driver ${socket.userId} disconnected`);
      connectedClients.delete(socket.userId);
    });

    // Handle error
    socket.on('error', (err) => {
      console.error(`❌ Socket error for driver ${socket.userId}:`, err);
    });
    
    // Handle chat messages
    socket.on('send_message', async (data) => {
      console.log(`💬 Message from driver ${socket.userId}:`, data);
      
      try {
        // Save message to database
        const { Message } = require('@shared-utils/dbModels');
        const message = await Message.create({
          rideId: data.rideId,
          senderId: socket.userId,
          recipientId: data.recipientId,
          content: data.content,
          messageType: data.messageType || 'text'
        });
        
        // Emit to recipient
        emitToUser(data.recipientId, 'receive_message', {
          ...data,
          messageId: message.id,
          senderId: socket.userId,
          sentAt: new Date()
        });
        
        // Also emit to sender for confirmation
        socket.emit('message_sent', {
          ...data,
          messageId: message.id,
          sentAt: new Date()
        });
      } catch (error) {
        console.error(`❌ Error sending message from driver ${socket.userId}:`, error);
        socket.emit('message_error', {
          error: 'Failed to send message',
          originalData: data
        });
      }
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