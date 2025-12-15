const express = require('express');
const { jwtUtils, passwordUtils, authenticate } = require('@uber-clone/shared-utils');
const router = express.Router();

// In-memory user storage for demonstration
// In a real application, this would be a database
const users = [
  {
    id: 'demo-rider',
    email: 'rider@uber.com',
    password: '$2a$10$8K1p/a0dURXAm7QiTRqNa.E3YPWsMDpkuFGilgF4DNZPaJ3SaD06W', // 'password123' hashed
    firstName: 'Demo',
    lastName: 'Rider',
    role: 'rider',
    phoneNumber: '+1234567890',
    status: 'active'
  },
  {
    id: 'demo-driver',
    email: 'driver@uber.com',
    password: '$2a$10$8K1p/a0dURXAm7QiTRqNa.E3YPWsMDpkuFGilgF4DNZPaJ3SaD06W', // 'password123' hashed
    firstName: 'Demo',
    lastName: 'Driver',
    role: 'driver',
    phoneNumber: '+1234567891',
    status: 'active',
    vehicle: {
      make: 'Toyota',
      model: 'Camry',
      year: 2020,
      licensePlate: 'ABC123',
      color: 'White'
    }
  },
  {
    id: 'demo-admin',
    email: 'admin@uber.com',
    password: '$2a$10$8K1p/a0dURXAm7QiTRqNa.E3YPWsMDpkuFGilgF4DNZPaJ3SaD06W', // 'password123' hashed
    firstName: 'Demo',
    lastName: 'Admin',
    role: 'admin',
    phoneNumber: '+1234567892',
    status: 'active'
  }
];

// Authentication controller
const authController = {
  register: async (req, res) => {
    try {
      const { email, password, firstName, lastName, phoneNumber, role } = req.body;
      
      // Validate input
      if (!email || !password || !firstName || !lastName) {
        return res.status(400).json({
          success: false,
          message: 'Missing required fields: email, password, firstName, lastName'
        });
      }
      
      // Check if user already exists
      const existingUser = users.find(user => user.email === email);
      if (existingUser) {
        return res.status(409).json({
          success: false,
          message: 'User with this email already exists'
        });
      }
      
      // Hash the password
      const hashedPassword = await passwordUtils.hashPassword(password);
      
      // Create new user
      const newUser = {
        id: `user-${Date.now()}`,
        email,
        password: hashedPassword,
        firstName,
        lastName,
        phoneNumber: phoneNumber || '',
        role: role || 'rider',
        status: 'active'
      };
      
      // Add to users array (in real app, save to database)
      users.push(newUser);
      
      // Generate JWT token
      const token = jwtUtils.signToken(
        { 
          id: newUser.id,
          email: newUser.email,
          role: newUser.role
        },
        process.env.JWT_SECRET || 'uber_clone_secret_key_for_development_only',
        process.env.JWT_EXPIRES_IN || '24h'
      );
      
      // Remove password from response
      const { password: _, ...userWithoutPassword } = newUser;
      
      res.status(201).json({ 
        success: true, 
        message: 'User registered successfully',
        token,
        user: userWithoutPassword
      });
    } catch (error) {
      res.status(500).json({ 
        success: false, 
        message: 'Error registering user',
        error: process.env.NODE_ENV === 'development' ? error.message : {}
      });
    }
  },
  
  login: async (req, res) => {
    try {
      const { email, password } = req.body;
      
      // Validate input
      if (!email || !password) {
        return res.status(400).json({
          success: false,
          message: 'Missing required fields: email, password'
        });
      }
      
      // Find user
      const user = users.find(user => user.email === email);
      if (!user) {
        return res.status(401).json({
          success: false,
          message: 'Invalid email or password'
        });
      }
      
      // Verify password
      const isPasswordValid = await passwordUtils.comparePassword(password, user.password);
      if (!isPasswordValid) {
        return res.status(401).json({
          success: false,
          message: 'Invalid email or password'
        });
      }
      
      // Generate JWT token
      const token = jwtUtils.signToken(
        { 
          id: user.id,
          email: user.email,
          role: user.role
        },
        process.env.JWT_SECRET || 'uber_clone_secret_key_for_development_only',
        process.env.JWT_EXPIRES_IN || '24h'
      );
      
      // Remove password from response
      const { password: _, ...userWithoutPassword } = user;
      
      res.json({ 
        success: true, 
        token,
        user: userWithoutPassword
      });
    } catch (error) {
      res.status(500).json({ 
        success: false, 
        message: 'Error logging in',
        error: process.env.NODE_ENV === 'development' ? error.message : {}
      });
    }
  },
  
  demoLogin: (req, res) => {
    // In development mode, bypass authentication
    if (process.env.NODE_ENV === 'development') {
      // Generate JWT token using shared utility
      const demoToken = jwtUtils.signToken(
        { 
          id: 'demo-rider',
          email: 'rider@uber.com',
          role: 'rider'
        },
        process.env.JWT_SECRET || 'uber_clone_secret_key_for_development_only',
        process.env.JWT_EXPIRES_IN || '24h'
      );
      
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
  },
  
  profile: (req, res) => {
    try {
      // Get user from token (attached by authentication middleware)
      const userId = req.user.id;
      
      // Find user
      const user = users.find(user => user.id === userId);
      if (!user) {
        return res.status(404).json({
          success: false,
          message: 'User not found'
        });
      }
      
      // Remove password from response
      const { password: _, ...userWithoutPassword } = user;
      
      res.json({
        success: true,
        user: userWithoutPassword
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error fetching profile',
        error: process.env.NODE_ENV === 'development' ? error.message : {}
      });
    }
  },
  
  updateProfile: async (req, res) => {
    try {
      const userId = req.user.id;
      const updates = req.body;
      
      // Find user
      const userIndex = users.findIndex(user => user.id === userId);
      if (userIndex === -1) {
        return res.status(404).json({
          success: false,
          message: 'User not found'
        });
      }
      
      // Update user fields
      const allowedUpdates = ['firstName', 'lastName', 'phoneNumber'];
      for (const key of allowedUpdates) {
        if (updates[key] !== undefined) {
          users[userIndex][key] = updates[key];
        }
      }
      
      // Update password if provided
      if (updates.password) {
        users[userIndex].password = await passwordUtils.hashPassword(updates.password);
      }
      
      // Update timestamp
      users[userIndex].updatedAt = new Date().toISOString();
      
      // Remove password from response
      const { password: _, ...userWithoutPassword } = users[userIndex];
      
      res.json({
        success: true,
        message: 'Profile updated successfully',
        user: userWithoutPassword
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error updating profile',
        error: process.env.NODE_ENV === 'development' ? error.message : {}
      });
    }
  }
};

// Register route
router.post('/register', express.json({ strict: false }), authController.register);

// Login route
router.post('/login', express.json({ strict: false }), authController.login);

// Demo login route
router.post('/demo/login/rider', express.json({ strict: false }), authController.demoLogin);

// Profile routes (protected)
router.get('/profile', authenticate(['rider']), authController.profile);
router.put('/profile', authenticate(['rider']), authController.updateProfile);

module.exports = router;