const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const authMiddleware = require('../middleware/authMiddleware');

// Get dashboard stats
router.get('/dashboard', authMiddleware.authMiddleware, authMiddleware.authorize(['admin']), adminController.getDashboardStats);

// Get all users
router.get('/users', authMiddleware.authMiddleware, authMiddleware.authorize(['admin']), adminController.getAllUsers);

// Get all rides
router.get('/rides', authMiddleware.authMiddleware, authMiddleware.authorize(['admin']), adminController.getAllRides);

// Get system health
router.get('/health', authMiddleware.authMiddleware, authMiddleware.authorize(['admin']), adminController.getSystemHealth);

module.exports = router;