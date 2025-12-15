const express = require('express');
const router = express.Router();
const { body, param } = require('express-validator');
const { validateRequest, validateCoordinates, xssProtection } = require('@shared-utils/securityUtils');
const rideController = require('../controllers/rideController');
const authenticate = require('@shared-utils/authMiddleware');

// Validation middleware
const createRideValidation = [
  body('pickupAddress').trim().notEmpty().withMessage('Pickup address is required').isLength({ max: 200 }).withMessage('Pickup address too long'),
  body('dropoffAddress').trim().notEmpty().withMessage('Dropoff address is required').isLength({ max: 200 }).withMessage('Dropoff address too long'),
  body('pickupLatitude').isFloat({ min: -90, max: 90 }).withMessage('Valid pickup latitude is required'),
  body('pickupLongitude').isFloat({ min: -180, max: 180 }).withMessage('Valid pickup longitude is required'),
  body('dropoffLatitude').isFloat({ min: -90, max: 90 }).withMessage('Valid dropoff latitude is required'),
  body('dropoffLongitude').isFloat({ min: -180, max: 180 }).withMessage('Valid dropoff longitude is required'),
  body('estimatedFare').isFloat({ min: 0 }).withMessage('Valid estimated fare is required')
];

// Create a new ride
router.post('/', authenticate, xssProtection, createRideValidation, validateRequest, rideController.createRide);

// Get a specific ride
router.get('/:id', authenticate, [
  param('id').isUUID().withMessage('Valid ride ID is required')
], validateRequest, rideController.getRide);

// Get all rides for user
router.get('/', authenticate, rideController.getRides);

// Get a specific ride with locations
router.get('/:id/locations', authenticate, [
  param('id').isUUID().withMessage('Valid ride ID is required')
], validateRequest, rideController.getRide);

// Cancel a ride
router.post('/:id/cancel', authenticate, [
  param('id').isUUID().withMessage('Valid ride ID is required')
], validateRequest, rideController.cancelRide);

module.exports = router;