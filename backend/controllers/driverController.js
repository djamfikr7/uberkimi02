const { validationResult } = require('express-validator');
const createError = require('http-errors');
const DriverService = require('../services/driverService');

// Register as driver
const registerAsDriver = async (req, res, next) => {
  try {
    // Validate request
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'VALIDATION_ERROR',
        message: 'Validation failed',
        details: errors.array()
      });
    }

    const driverData = req.body;

    // Register as driver using service
    const driver = await DriverService.registerAsDriver(req.user.id, driverData);

    res.status(201).json({
      success: true,
      message: 'Driver registration successful',
      data: {
        driver
      }
    });

  } catch (error) {
    console.error('Register as driver error:', error);
    next(error);
  }
};

// Get driver profile
const getDriverProfile = async (req, res, next) => {
  try {
    // Get driver profile using service
    const driver = await DriverService.getDriverProfile(req.user.id);

    res.json({
      success: true,
      message: 'Driver profile retrieved successfully',
      data: {
        driver
      }
    });

  } catch (error) {
    console.error('Get driver profile error:', error);
    next(error);
  }
};

// Update driver profile
const updateDriverProfile = async (req, res, next) => {
  try {
    // Validate request
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'VALIDATION_ERROR',
        message: 'Validation failed',
        details: errors.array()
      });
    }

    const updateData = req.body;

    // Update driver profile using service
    const driver = await DriverService.updateDriverProfile(req.user.id, updateData);

    res.json({
      success: true,
      message: 'Driver profile updated successfully',
      data: {
        driver
      }
    });

  } catch (error) {
    console.error('Update driver profile error:', error);
    next(error);
  }
};

// Update driver online status
const updateDriverOnlineStatus = async (req, res, next) => {
  try {
    const { isOnline } = req.body;

    // Update driver online status using service
    const driver = await DriverService.updateDriverOnlineStatus(req.user.id, isOnline);

    res.json({
      success: true,
      message: `Driver is now ${isOnline ? 'online' : 'offline'}`,
      data: {
        driver
      }
    });

  } catch (error) {
    console.error('Update driver online status error:', error);
    next(error);
  }
};

// Update driver location
const updateDriverLocation = async (req, res, next) => {
  try {
    const { location } = req.body;

    // Update driver location using service
    const driver = await DriverService.updateDriverLocation(req.user.id, location);

    res.json({
      success: true,
      message: 'Driver location updated successfully',
      data: {
        driver
      }
    });

  } catch (error) {
    console.error('Update driver location error:', error);
    next(error);
  }
};

// Get available drivers near location
const getAvailableDrivers = async (req, res, next) => {
  try {
    const { latitude, longitude, radius, limit } = req.query;

    const location = {
      type: 'Point',
      coordinates: [parseFloat(longitude), parseFloat(latitude)]
    };

    // Get available drivers using service
    const drivers = await DriverService.getAvailableDriversNearLocation(
      location,
      parseInt(radius) || 5000,
      parseInt(limit) || 10
    );

    res.json({
      success: true,
      message: 'Available drivers retrieved successfully',
      data: {
        drivers
      }
    });

  } catch (error) {
    console.error('Get available drivers error:', error);
    next(error);
  }
};

module.exports = {
  registerAsDriver,
  getDriverProfile,
  updateDriverProfile,
  updateDriverOnlineStatus,
  updateDriverLocation,
  getAvailableDrivers
};