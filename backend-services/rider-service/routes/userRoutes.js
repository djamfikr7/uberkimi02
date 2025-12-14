const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const authMiddleware = require('../middleware/authMiddleware');

// Get user profile
router.get('/profile', authMiddleware.authMiddleware, userController.getProfile);

// Update user profile
router.put('/profile', authMiddleware.authMiddleware, userController.updateProfile);

// Get user rides
router.get('/rides', authMiddleware.authMiddleware, userController.getUserRides);

// Get user payments
router.get('/payments', authMiddleware.authMiddleware, userController.getUserPayments);

module.exports = router;