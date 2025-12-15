const { Ride, User } = require('@shared-utils/dbModels');
const { fraudDetection } = require('@shared-utils');
const { Op } = require('sequelize');
const { validationResult } = require('express-validator');

// Policy constants
const CANCELLATION_TIME_THRESHOLD = 5 * 60 * 1000; // 5 minutes in milliseconds
const COOLDOWN_PERIOD = 10 * 60 * 1000; // 10 minutes in milliseconds

/**
 * Create a new ride request
 */
async function createRide(req, res) {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    const {
      pickupAddress,
      dropoffAddress,
      pickupLatitude,
      pickupLongitude,
      dropoffLatitude,
      dropoffLongitude,
      estimatedFare,
      vehicleType
    } = req.body;

    const riderId = req.user.id;

    // Check if rider has any active rides
    const activeRide = await Ride.findOne({
      where: {
        riderId: riderId,
        status: {
          [Op.in]: ['requested', 'accepted', 'arrived', 'in_progress']
        }
      }
    });

    if (activeRide) {
      return res.status(400).json({
        success: false,
        message: 'You already have an active ride request'
      });
    }

    // Check rider cooldown period
    const recentCancelledRide = await Ride.findOne({
      where: {
        riderId: riderId,
        status: 'cancelled',
        cancelledAt: {
          [Op.gt]: new Date(Date.now() - COOLDOWN_PERIOD)
        }
      },
      order: [['cancelledAt', 'DESC']]
    });

    if (recentCancelledRide) {
      const timeSinceCancellation = Date.now() - new Date(recentCancelledRide.cancelledAt).getTime();
      const remainingCooldown = COOLDOWN_PERIOD - timeSinceCancellation;
      
      if (remainingCooldown > 0) {
        return res.status(400).json({
          success: false,
          message: `You must wait ${Math.ceil(remainingCooldown / 60000)} minutes before requesting another ride`
        });
      }
    }

    // Run fraud detection checks
    const fraudCheck = await fraudDetection.runFraudChecks(riderId);
    if (fraudCheck.flagged) {
      console.warn(`Fraud detection triggered for user ${riderId}: ${fraudCheck.message}`);
      // In a production environment, you might want to:
      // 1. Temporarily suspend the user
      // 2. Require additional verification
      // 3. Notify administrators
      // For now, we'll just log it but still allow the ride to proceed
    }

    // Create the ride
    const ride = await Ride.create({
      riderId: riderId,
      pickupAddress,
      dropoffAddress,
      pickupLocation: {
        type: 'Point',
        coordinates: [pickupLongitude, pickupLatitude]
      },
      dropoffLocation: {
        type: 'Point',
        coordinates: [dropoffLongitude, dropoffLatitude]
      },
      baseFare: estimatedFare,
      vehicleType: vehicleType || 'uber-x',
      status: 'requested'
    });

    // Emit new ride request event for drivers
    const socketServer = req.app.get('socketServer');
    socketServer.broadcastEvent('new_ride_request', {
      rideId: ride.id,
      riderId: ride.riderId,
      pickupAddress: ride.pickupAddress,
      dropoffAddress: ride.dropoffAddress,
      pickupLatitude: ride.pickupLocation.coordinates[1],
      pickupLongitude: ride.pickupLocation.coordinates[0],
      dropoffLatitude: ride.dropoffLocation.coordinates[1],
      dropoffLongitude: ride.dropoffLocation.coordinates[0],
      baseFare: ride.baseFare,
      vehicleType: ride.vehicleType,
      requestedAt: ride.requestedAt
    });

    res.status(201).json({
      success: true,
      message: 'Ride requested successfully',
      ride: ride
    });
  } catch (error) {
    console.error('Error creating ride:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating ride',
      error: process.env.NODE_ENV === 'development' ? error.message : {}
    });
  }
}

/**
 * Get a specific ride
 */
async function getRide(req, res) {
  try {
    const { id } = req.params;
    const userId = req.user.id;

    const ride = await Ride.findByPk(id, {
      include: [
        {
          model: User,
          as: 'rider',
          attributes: ['id', 'firstName', 'lastName', 'phoneNumber']
        },
        {
          model: User,
          as: 'driver',
          attributes: ['id', 'firstName', 'lastName', 'phoneNumber']
        }
      ]
    });

    if (!ride) {
      return res.status(404).json({
        success: false,
        message: 'Ride not found'
      });
    }

    // Check if user is authorized to view this ride
    if (ride.riderId !== userId && ride.driverId !== userId) {
      return res.status(403).json({
        success: false,
        message: 'You are not authorized to view this ride'
      });
    }

    res.status(200).json({
      success: true,
      ride: ride
    });
  } catch (error) {
    console.error('Error retrieving ride:', error);
    res.status(500).json({
      success: false,
      message: 'Error retrieving ride',
      error: process.env.NODE_ENV === 'development' ? error.message : {}
    });
  }
}

/**
 * Get all rides for the current user
 */
async function getRides(req, res) {
  try {
    const userId = req.user.id;
    const { status, limit = 20, offset = 0 } = req.query;

    const whereClause = {
      [Op.or]: [
        { riderId: userId },
        { driverId: userId }
      ]
    };

    if (status) {
      whereClause.status = status;
    }

    const rides = await Ride.findAll({
      where: whereClause,
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [['requestedAt', 'DESC']],
      include: [
        {
          model: User,
          as: 'rider',
          attributes: ['id', 'firstName', 'lastName', 'phoneNumber']
        },
        {
          model: User,
          as: 'driver',
          attributes: ['id', 'firstName', 'lastName', 'phoneNumber']
        }
      ]
    });

    res.status(200).json({
      success: true,
      rides: rides
    });
  } catch (error) {
    console.error('Error retrieving rides:', error);
    res.status(500).json({
      success: false,
      message: 'Error retrieving rides',
      error: process.env.NODE_ENV === 'development' ? error.message : {}
    });
  }
}

/**
 * Cancel a ride
 */
async function cancelRide(req, res) {
  try {
    const { id } = req.params;
    const userId = req.user.id;

    const ride = await Ride.findByPk(id);

    if (!ride) {
      return res.status(404).json({
        success: false,
        message: 'Ride not found'
      });
    }

    // Check if user is authorized to cancel this ride
    if (ride.riderId !== userId) {
      return res.status(403).json({
        success: false,
        message: 'You are not authorized to cancel this ride'
      });
    }

    // Check if ride can be cancelled based on status
    if (!['requested', 'accepted'].includes(ride.status)) {
      return res.status(400).json({
        success: false,
        message: 'This ride cannot be cancelled at this stage'
      });
    }

    // Check cancellation time threshold for accepted rides
    if (ride.status === 'accepted' && ride.acceptedAt) {
      const timeSinceAcceptance = Date.now() - new Date(ride.acceptedAt).getTime();
      if (timeSinceAcceptance > CANCELLATION_TIME_THRESHOLD) {
        return res.status(400).json({
          success: false,
          message: 'Cannot cancel ride after 5 minutes of acceptance'
        });
      }
    }

    // Update ride status
    ride.status = 'cancelled';
    ride.cancelledAt = new Date();
    await ride.save();

    // Emit ride status update event
    const socketServer = req.app.get('socketServer');
    socketServer.broadcastEvent('ride_status_updated', {
      rideId: ride.id,
      status: ride.status,
      cancelledAt: ride.cancelledAt,
      updatedBy: userId
    });

    res.status(200).json({
      success: true,
      message: 'Ride cancelled successfully',
      ride: ride
    });
  } catch (error) {
    console.error('Error cancelling ride:', error);
    res.status(500).json({
      success: false,
      message: 'Error cancelling ride',
      error: process.env.NODE_ENV === 'development' ? error.message : {}
    });
  }
}

module.exports = {
  createRide,
  getRide,
  getRides,
  cancelRide
};