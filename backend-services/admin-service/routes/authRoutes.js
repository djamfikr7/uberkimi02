const express = require('express');
const router = express.Router();
const { check } = require('express-validator');
const authController = require('../controllers/authController');
const authMiddleware = require('../middleware/authMiddleware');

// Login route (bypass OTP as requested)
router.post(
  '/login',
  [
    check('email').isEmail().withMessage('Please provide a valid email'),
    check('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters')
  ],
  authController.login
);

// Register route
router.post(
  '/register',
  [
    check('email').isEmail().withMessage('Please provide a valid email'),
    check('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
    check('firstName').not().isEmpty().withMessage('First name is required'),
    check('lastName').not().isEmpty().withMessage('Last name is required'),
    check('phoneNumber').isMobilePhone().withMessage('Please provide a valid phone number'),
    check('userType').optional().isIn(['rider', 'driver', 'admin']).withMessage('Invalid user type')
  ],
  authController.register
);

// Get current user route (protected)
router.get('/me', authMiddleware.authMiddleware, authController.getCurrentUser);

// Demo login routes for quick testing
router.post('/demo/login/rider', (req, res) => {
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

router.post('/demo/login/driver', (req, res) => {
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

router.post('/demo/login/admin', (req, res) => {
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

module.exports = router;