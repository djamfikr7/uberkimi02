const express = require('express');
const router = express.Router();
const rideController = require('../controllers/rideController');
const authMiddleware = require('../middleware/authMiddleware');
const { check } = require('express-validator');

// Create ride
router.post(
    '/',
    authMiddleware.authMiddleware,
    [
        check('pickupLocation').not().isEmpty().withMessage('Pickup location is required'),
        check('dropoffLocation').not().isEmpty().withMessage('Dropoff location is required'),
        check('pickupAddress').not().isEmpty().withMessage('Pickup address is required'),
        check('dropoffAddress').not().isEmpty().withMessage('Dropoff address is required'),
        check('baseFare').isNumeric().withMessage('Base fare must be a number')
    ],
    rideController.createRide
);

// Get ride by ID
router.get('/:rideId', authMiddleware.authMiddleware, rideController.getRideById);

// Get my rides
router.get('/', authMiddleware.authMiddleware, rideController.getMyRides);

// Update ride status
router.put(
    '/:rideId/status',
    authMiddleware.authMiddleware,
    [
        check('status').isIn(['requested', 'accepted', 'in_progress', 'completed', 'cancelled'])
            .withMessage('Invalid status value')
    ],
    rideController.updateRideStatus
);

// Accept ride (driver only)
router.put('/:rideId/accept', authMiddleware.authMiddleware, rideController.acceptRide);

// Calculate fare
router.post('/:rideId/calculate-fare', authMiddleware.authMiddleware, rideController.calculateFare);

module.exports = router;