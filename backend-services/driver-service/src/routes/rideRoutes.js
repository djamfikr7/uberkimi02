const express = require('express');
const router = express.Router();
const { param, body } = require('express-validator');
const rideController = require('../controllers/rideController');
const authenticate = require('@shared-utils/authMiddleware');

// Get available rides
router.get('/available', authenticate, rideController.getAvailableRides);

// Get a specific ride
router.get('/:id', authenticate, [
  param('id').isUUID().withMessage('Valid ride ID is required')
], rideController.getRide);

// Get a specific ride with locations
router.get('/:id/locations', authenticate, [
  param('id').isUUID().withMessage('Valid ride ID is required')
], rideController.getRide);

// Accept a ride
router.post('/:id/accept', authenticate, [
  param('id').isUUID().withMessage('Valid ride ID is required')
], rideController.acceptRide);

// Start a ride
router.post('/:id/start', authenticate, [
  param('id').isUUID().withMessage('Valid ride ID is required')
], rideController.startRide);

// Complete a ride
router.post('/:id/complete', authenticate, [
  param('id').isUUID().withMessage('Valid ride ID is required'),
  body('actualFare').optional().isNumeric().withMessage('Valid actual fare is required')
], rideController.completeRide);

module.exports = router;