const express = require('express');
const router = express.Router();
const driverController = require('../controllers/driverController');
const authMiddleware = require('../middleware/authMiddleware');
const { check } = require('express-validator');

// Register as driver
router.post(
    '/register',
    authMiddleware.authMiddleware,
    [
        check('licenseNumber').not().isEmpty().withMessage('License number is required'),
        check('vehicleType').isIn(['uber-x', 'uber-xl', 'comfort', 'black', 'pool'])
            .withMessage('Invalid vehicle type'),
        check('vehicleMake').not().isEmpty().withMessage('Vehicle make is required'),
        check('vehicleModel').not().isEmpty().withMessage('Vehicle model is required'),
        check('vehicleYear').isInt({ min: 2000, max: new Date().getFullYear() + 1 })
            .withMessage('Invalid vehicle year'),
        check('vehicleColor').not().isEmpty().withMessage('Vehicle color is required'),
        check('licensePlate').not().isEmpty().withMessage('License plate is required')
    ],
    driverController.registerAsDriver
);

// Get driver profile
router.get('/profile', authMiddleware.authMiddleware, driverController.getDriverProfile);

// Update driver profile
router.put(
    '/profile',
    authMiddleware.authMiddleware,
    [
        check('vehicleType').optional().isIn(['uber-x', 'uber-xl', 'comfort', 'black', 'pool'])
            .withMessage('Invalid vehicle type'),
        check('vehicleMake').optional().not().isEmpty().withMessage('Vehicle make cannot be empty'),
        check('vehicleModel').optional().not().isEmpty().withMessage('Vehicle model cannot be empty'),
        check('vehicleColor').optional().not().isEmpty().withMessage('Vehicle color cannot be empty')
    ],
    driverController.updateDriverProfile
);

// Update driver online status
router.put(
    '/status',
    authMiddleware.authMiddleware,
    [
        check('isOnline').isBoolean().withMessage('isOnline must be a boolean')
    ],
    driverController.updateDriverOnlineStatus
);

// Update driver location
router.put(
    '/location',
    authMiddleware.authMiddleware,
    [
        check('location.type').equals('Point').withMessage('Location type must be Point'),
        check('location.coordinates').isArray({ min: 2, max: 2 })
            .withMessage('Location coordinates must be [longitude, latitude]')
    ],
    driverController.updateDriverLocation
);

// Get available drivers near location
router.get(
    '/available',
    authMiddleware.authMiddleware,
    [
        check('latitude').isFloat().withMessage('Latitude must be a number'),
        check('longitude').isFloat().withMessage('Longitude must be a number')
    ],
    driverController.getAvailableDrivers
);

module.exports = router;