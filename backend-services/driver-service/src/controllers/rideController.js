const { Ride, User, Driver } = require('@shared-utils/dbModels');
const { fraudDetection } = require('@shared-utils');
const { Op } = require('sequelize');
const { validationResult } = require('express-validator');

/**
 * Get available rides for the driver
 */
async function getAvailableRides(req, res) {
  try {
    const driverId = req.user.id;

    // Get driver's vehicle type
    const driver = await Driver.findOne({ where: { userId: driverId } });
    if (!driver) {
      return res.status(404).json({
        success: false,
        message: 'Driver profile not found'
      });
    }

    // Get available rides matching driver's vehicle type
    const rides = await Ride.findAll({
      where: {
        status: 'requested',
        vehicleType: driver.vehicleType,
        // Exclude rides that were requested more than 30 minutes ago
        requestedAt: {
          [Op.gt]: new Date(Date.now() - 30 * 60 * 1000)
        }
      },
      include: [
        {
          model: User,
          as: 'rider',
          attributes: ['id', 'firstName', 'lastName', 'phoneNumber']
        }
      ],
      order: [['requestedAt', 'DESC']],
      limit: 20
    });

    res.status(200).json({
      success: true,
      rides: rides
    });
  } catch (error) {
    console.error('Error retrieving available rides:', error);
    res.status(500).json({
      success: false,
      message: 'Error retrieving available rides',
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
 * Accept a ride
 */
async function acceptRide(req, res) {
  try {
    const { id } = req.params;
    const driverId = req.user.id;

    const ride = await Ride.findByPk(id);

    if (!ride) {
      return res.status(404).json({
        success: false,
        message: 'Ride not found'
      });
    }

    // Check if ride is still available
    if (ride.status !== 'requested') {
      return res.status(400).json({
        success: false,
        message: 'This ride is no longer available'
      });
    }

    // Check if driver has an active ride
    const activeRide = await Ride.findOne({
      where: {
        driverId: driverId,
        status: {
          [Op.in]: ['accepted', 'arrived', 'in_progress']
        }
      }
    });

    if (activeRide) {
      return res.status(400).json({
        success: false,
        message: 'You already have an active ride'
      });
    }

    // Update ride with driver assignment
    ride.driverId = driverId;
    ride.status = 'accepted';
    ride.acceptedAt = new Date();
    await ride.save();

    // Emit ride status update event
    const socketServer = req.app.get('socketServer');
    socketServer.broadcastEvent('ride_status_updated', {
      rideId: ride.id,
      status: ride.status,
      driverId: ride.driverId,
      acceptedAt: ride.acceptedAt
    });

    res.status(200).json({
      success: true,
      message: 'Ride accepted successfully',
      ride: ride
    });
  } catch (error) {
    console.error('Error accepting ride:', error);
    res.status(500).json({
      success: false,
      message: 'Error accepting ride',
      error: process.env.NODE_ENV === 'development' ? error.message : {}
    });
  }
}

/**
 * Start a ride
 */
async function startRide(req, res) {
  try {
    const { id } = req.params;
    const driverId = req.user.id;

    const ride = await Ride.findByPk(id);

    if (!ride) {
      return res.status(404).json({
        success: false,
        message: 'Ride not found'
      });
    }

    // Check if user is authorized to start this ride
    if (ride.driverId !== driverId) {
      return res.status(403).json({
        success: false,
        message: 'You are not authorized to start this ride'
      });
    }

    // Check if ride is in correct status
    if (ride.status !== 'accepted') {
      return res.status(400).json({
        success: false,
        message: 'Ride must be accepted before it can be started'
      });
    }

    // Update ride status
    ride.status = 'in_progress';
    ride.startedAt = new Date();
    await ride.save();

    // Emit ride status update event
    const socketServer = req.app.get('socketServer');
    socketServer.broadcastEvent('ride_status_updated', {
      rideId: ride.id,
      status: ride.status,
      startedAt: ride.startedAt
    });

    res.status(200).json({
      success: true,
      message: 'Ride started successfully',
      ride: ride
    });
  } catch (error) {
    console.error('Error starting ride:', error);
    res.status(500).json({
      success: false,
      message: 'Error starting ride',
      error: process.env.NODE_ENV === 'development' ? error.message : {}
    });
  }
}

/**
 * Complete a ride
 */
async function completeRide(req, res) {
  try {
    const { id } = req.params;
    const { actualFare } = req.body;
    const driverId = req.user.id;

    const ride = await Ride.findByPk(id);

    if (!ride) {
      return res.status(404).json({
        success: false,
        message: 'Ride not found'
      });
    }

    // Check if user is authorized to complete this ride
    if (ride.driverId !== driverId) {
      return res.status(403).json({
        success: false,
        message: 'You are not authorized to complete this ride'
      });
    }

    // Check if ride is in correct status
    if (ride.status !== 'in_progress') {
      return res.status(400).json({
        success: false,
        message: 'Ride must be in progress before it can be completed'
      });
    }

    // Update ride status
    ride.status = 'completed';
    ride.completedAt = new Date();
    ride.finalFare = actualFare || ride.baseFare;
    await ride.save();

    // Run fraud detection on completed ride
    const fraudCheck = await fraudDetection.checkSuspiciousRide(ride.id);
    if (fraudCheck.isSuspicious) {
      console.warn(`Suspicious ride detected: ${fraudCheck.reason}`);
      // In a production environment, you might want to:
      // 1. Flag the ride for review
      // 2. Notify administrators
      // 3. Investigate further
      // For now, we'll just log it
    }

    // Emit ride status update event
    const socketServer = req.app.get('socketServer');
    socketServer.broadcastEvent('ride_status_updated', {
      rideId: ride.id,
      status: ride.status,
      completedAt: ride.completedAt,
      finalFare: ride.finalFare
    });

    res.status(200).json({
      success: true,
      message: 'Ride completed successfully',
      ride: ride
    });
  } catch (error) {
    console.error('Error completing ride:', error);
    res.status(500).json({
      success: false,
      message: 'Error completing ride',
      error: process.env.NODE_ENV === 'development' ? error.message : {}
    });
  }
}

module.exports = {
  getAvailableRides,
  getRide,
  acceptRide,
  startRide,
  completeRide
};