const { validationResult } = require('express-validator');
const createError = require('http-errors');
const RideService = require('../services/rideService');

// Create a new ride
const createRide = async (req, res, next) => {
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

    const rideData = {
      ...req.body,
      riderId: req.user.id // From authMiddleware
    };

    // Create ride using service
    const ride = await RideService.createRide(rideData);

    res.status(201).json({
      success: true,
      message: 'Ride created successfully',
      data: {
        ride
      }
    });

  } catch (error) {
    console.error('Create ride error:', error);
    next(error);
  }
};

// Get ride by ID
const getRideById = async (req, res, next) => {
  try {
    const { rideId } = req.params;

    // Get ride using service
    const ride = await RideService.getRideById(rideId);

    res.json({
      success: true,
      message: 'Ride retrieved successfully',
      data: {
        ride
      }
    });

  } catch (error) {
    console.error('Get ride by ID error:', error);
    next(error);
  }
};

// Get rides by current user (rider)
const getMyRides = async (req, res, next) => {
  try {
    const { status } = req.query;
    const options = {};

    if (status) {
      options.status = status;
    }

    // Get rides using service
    const rides = await RideService.getRidesByRider(req.user.id, options);

    res.json({
      success: true,
      message: 'Rides retrieved successfully',
      data: {
        rides
      }
    });

  } catch (error) {
    console.error('Get my rides error:', error);
    next(error);
  }
};

// Update ride status
const updateRideStatus = async (req, res, next) => {
  try {
    const { rideId } = req.params;
    const { status } = req.body;
    const userId = req.user.id; // Get user ID from auth middleware

    // Update ride status using service
    const ride = await RideService.updateRideStatus(rideId, status, {}, userId);

    res.json({
      success: true,
      message: 'Ride status updated successfully',
      data: {
        ride
      }
    });

  } catch (error) {
    console.error('Update ride status error:', error);
    next(error);
  }
};

// Accept ride as driver
const acceptRide = async (req, res, next) => {
  try {
    const { rideId } = req.params;
    const driverId = req.user.id; // Get driver ID from auth middleware

    // Accept ride using service
    const ride = await RideService.acceptRide(rideId, driverId);

    res.json({
      success: true,
      message: 'Ride accepted successfully',
      data: {
        ride
      }
    });

  } catch (error) {
    console.error('Accept ride error:', error);
    next(error);
  }
};

// Calculate ride fare
const calculateFare = async (req, res, next) => {
  try {
    const { rideId } = req.params;

    // Calculate fare using service
    const ride = await RideService.calculateFare(rideId);

    res.json({
      success: true,
      message: 'Fare calculated successfully',
      data: {
        ride
      }
    });

  } catch (error) {
    console.error('Calculate fare error:', error);
    next(error);
  }
};

// Update ride payment status
const updatePaymentStatus = async (req, res, next) => {
  try {
    const { rideId } = req.params;
    const { paymentStatus } = req.body;

    // Update ride payment status using service
    const ride = await RideService.updatePaymentStatus(rideId, paymentStatus);

    res.json({
      success: true,
      message: 'Ride payment status updated successfully',
      data: {
        ride
      }
    });

  } catch (error) {
    console.error('Update ride payment status error:', error);
    next(error);
  }
};

// Submit ride rating and feedback
const submitRating = async (req, res, next) => {
  try {
    const { rideId } = req.params;
    const { rating, feedback } = req.body;
    const userId = req.user.id;
    const userType = req.user.userType;

    // Submit rating using service
    const ride = await RideService.submitRating(rideId, userType, rating, feedback);

    res.json({
      success: true,
      message: 'Rating submitted successfully',
      data: {
        ride
      }
    });

  } catch (error) {
    console.error('Submit rating error:', error);
    next(error);
  }
};

module.exports = {
  createRide,
  getRideById,
  getMyRides,
  updateRideStatus,
  acceptRide,
  calculateFare,
  updatePaymentStatus,
  submitRating
};