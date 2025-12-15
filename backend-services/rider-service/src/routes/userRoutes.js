const express = require('express');
const { User } = require('@uber-clone/shared-utils');
const router = express.Router();

// Mock user controller
const userController = {
  getProfile: (req, res) => {
    // Create user instance using shared model
    const userData = {
      id: 'user-id',
      email: 'user@example.com',
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '+1234567890',
      role: 'rider',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };
    
    const user = new User(userData);
    
    res.json({
      success: true,
      user: user
    });
  },
  
  updateProfile: (req, res) => {
    // Create user instance using shared model
    const userData = {
      id: 'user-id',
      email: req.body.email || 'user@example.com',
      firstName: req.body.firstName || 'John',
      lastName: req.body.lastName || 'Doe',
      phoneNumber: req.body.phoneNumber || '+1234567890',
      role: 'rider',
      updatedAt: new Date().toISOString()
    };
    
    const user = new User(userData);
    
    res.json({
      success: true,
      message: 'Profile updated successfully',
      user: user
    });
  }
};

// Get user profile
router.get('/profile', userController.getProfile);

// Update user profile
router.put('/profile', userController.updateProfile);

module.exports = router;