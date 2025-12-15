const express = require('express');
const { Ride } = require('@uber-clone/shared-utils');
const router = express.Router();

// Mock ride controller
const rideController = {
  getAllRides: (req, res) => {
    // Create ride instances using shared model
    const ride1Data = {
      id: 'ride-1',
      riderId: 'rider-1',
      driverId: 'driver-1',
      riderName: 'John Doe',
      driverName: 'Jane Smith',
      pickupAddress: '123 Main St',
      dropoffAddress: '456 Oak Ave',
      estimatedFare: 15.50,
      actualFare: 15.50,
      status: 'completed',
      requestedAt: new Date(Date.now() - 3600000).toISOString(), // 1 hour ago
      acceptedAt: new Date(Date.now() - 3500000).toISOString(),
      startedAt: new Date(Date.now() - 3400000).toISOString(),
      completedAt: new Date(Date.now() - 3300000).toISOString()
    };
    
    const ride2Data = {
      id: 'ride-2',
      riderId: 'rider-2',
      driverId: 'driver-2',
      riderName: 'Bob Johnson',
      driverName: 'Alice Brown',
      pickupAddress: '789 Pine St',
      dropoffAddress: '321 Elm St',
      estimatedFare: 12.75,
      actualFare: 12.75,
      status: 'in_progress',
      requestedAt: new Date(Date.now() - 1800000).toISOString(), // 30 minutes ago
      acceptedAt: new Date(Date.now() - 1700000).toISOString(),
      startedAt: new Date(Date.now() - 1600000).toISOString()
    };
    
    const ride3Data = {
      id: 'ride-3',
      riderId: 'rider-3',
      riderName: 'Charlie Wilson',
      pickupAddress: '456 Maple Ave',
      dropoffAddress: '987 Cedar Blvd',
      estimatedFare: 22.00,
      status: 'requested',
      requestedAt: new Date().toISOString()
    };
    
    const ride1 = new Ride(ride1Data);
    const ride2 = new Ride(ride2Data);
    const ride3 = new Ride(ride3Data);
    
    res.json({
      success: true,
      rides: [ride1, ride2, ride3]
    });
  },
  
  getRide: (req, res) => {
    // Create ride instance using shared model
    const rideData = {
      id: req.params.id,
      riderId: 'rider-id',
      driverId: 'driver-id',
      riderName: 'John Doe',
      driverName: 'Jane Smith',
      pickupAddress: '123 Main St',
      dropoffAddress: '456 Oak Ave',
      pickupLatitude: 40.7128,
      pickupLongitude: -74.0060,
      dropoffLatitude: 40.7589,
      dropoffLongitude: -73.9851,
      estimatedFare: 15.50,
      actualFare: 15.50,
      status: 'completed',
      requestedAt: new Date(Date.now() - 3600000).toISOString(), // 1 hour ago
      acceptedAt: new Date(Date.now() - 3500000).toISOString(),
      startedAt: new Date(Date.now() - 3400000).toISOString(),
      completedAt: new Date(Date.now() - 3300000).toISOString()
    };
    
    const ride = new Ride(rideData);
    
    res.json({
      success: true,
      ride: ride
    });
  },
  
  updateRideStatus: (req, res) => {
    // Create ride instance using shared model
    const rideData = {
      id: req.params.id,
      status: req.body.status,
      updatedAt: new Date().toISOString()
    };
    
    const ride = new Ride(rideData);
    
    res.json({
      success: true,
      message: 'Ride status updated successfully',
      ride: ride
    });
  }
};

// Get all rides
router.get('/', rideController.getAllRides);

// Get a specific ride
router.get('/:id', rideController.getRide);

// Update ride status
router.put('/:id/status', rideController.updateRideStatus);

module.exports = router;