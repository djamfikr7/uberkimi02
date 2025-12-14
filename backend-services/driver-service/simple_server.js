const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    message: 'Backend server is running with mock data'
  });
});

// Demo login endpoints
app.post('/api/auth/demo/login/rider', (req, res) => {
  res.json({
    success: true,
    message: 'Demo rider login successful',
    data: {
      token: 'demo_rider_token',
      user: {
        id: 'rider_123',
        email: 'rider@demo.com',
        firstName: 'Demo',
        lastName: 'Rider',
        userType: 'rider',
        phoneNumber: '+1234567890',
        profilePictureUrl: 'https://randomuser.me/api/portraits/men/1.jpg'
      }
    }
  });
});

app.post('/api/auth/demo/login/driver', (req, res) => {
  res.json({
    success: true,
    message: 'Demo driver login successful',
    data: {
      token: 'demo_driver_token',
      user: {
        id: 'driver_123',
        email: 'driver@demo.com',
        firstName: 'Demo',
        lastName: 'Driver',
        userType: 'driver',
        phoneNumber: '+1234567890',
        profilePictureUrl: 'https://randomuser.me/api/portraits/men/2.jpg'
      }
    }
  });
});

app.post('/api/auth/demo/login/admin', (req, res) => {
  res.json({
    success: true,
    message: 'Demo admin login successful',
    data: {
      token: 'demo_admin_token',
      user: {
        id: 'admin_123',
        email: 'admin@demo.com',
        firstName: 'Demo',
        lastName: 'Admin',
        userType: 'admin',
        phoneNumber: '+1234567890',
        profilePictureUrl: 'https://randomuser.me/api/portraits/women/1.jpg'
      }
    }
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Simple backend running on port ${PORT}`);
  console.log(`🌐 API available at http://localhost:${PORT}/api`);
});