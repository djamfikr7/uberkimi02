const express = require('express');
const { User } = require('@uber-clone/shared-utils');
const router = express.Router();

// Mock user controller
const userController = {
  getAllUsers: (req, res) => {
    // Create user instances using shared model
    const user1Data = {
      id: 'user-1',
      email: 'rider1@example.com',
      firstName: 'John',
      lastName: 'Doe',
      role: 'rider',
      status: 'active',
      createdAt: new Date(Date.now() - 86400000).toISOString() // 1 day ago
    };
    
    const user2Data = {
      id: 'user-2',
      email: 'driver1@example.com',
      firstName: 'Jane',
      lastName: 'Smith',
      role: 'driver',
      status: 'active',
      vehicle: {
        make: 'Toyota',
        model: 'Camry',
        year: 2020,
        licensePlate: 'ABC123'
      },
      createdAt: new Date(Date.now() - 172800000).toISOString() // 2 days ago
    };
    
    const user3Data = {
      id: 'user-3',
      email: 'rider2@example.com',
      firstName: 'Bob',
      lastName: 'Johnson',
      role: 'rider',
      status: 'suspended',
      createdAt: new Date(Date.now() - 259200000).toISOString() // 3 days ago
    };
    
    const user1 = new User(user1Data);
    const user2 = new User(user2Data);
    const user3 = new User(user3Data);
    
    res.json({
      success: true,
      users: [user1, user2, user3]
    });
  },
  
  getUser: (req, res) => {
    // Create user instance using shared model
    const userData = {
      id: req.params.id,
      email: 'user@example.com',
      firstName: 'John',
      lastName: 'Doe',
      role: req.params.role || 'rider',
      status: 'active',
      createdAt: new Date(Date.now() - 86400000).toISOString(), // 1 day ago
      updatedAt: new Date().toISOString()
    };
    
    const user = new User(userData);
    
    res.json({
      success: true,
      user: user
    });
  },
  
  updateUserStatus: (req, res) => {
    // Create user instance using shared model
    const userData = {
      id: req.params.id,
      status: req.body.status,
      updatedAt: new Date().toISOString()
    };
    
    const user = new User(userData);
    
    res.json({
      success: true,
      message: 'User status updated successfully',
      user: user
    });
  }
};

// Get all users
router.get('/', userController.getAllUsers);

// Get a specific user
router.get('/:id/:role', userController.getUser);

// Update user status
router.put('/:id/status', userController.updateUserStatus);

module.exports = router;