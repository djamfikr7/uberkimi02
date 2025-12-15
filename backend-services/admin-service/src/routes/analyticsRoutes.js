const express = require('express');
const { locationUtils } = require('@uber-clone/shared-utils');
const router = express.Router();

// Mock analytics controller
const analyticsController = {
  getDashboardStats: (req, res) => {
    res.json({
      success: true,
      stats: {
        totalRiders: 1250,
        totalDrivers: 320,
        totalRides: 4280,
        completedRides: 3980,
        cancelledRides: 300,
        activeRides: 15,
        totalRevenue: 25680.50,
        avgRideFare: 18.75,
        riderRetentionRate: 87.5,
        driverRetentionRate: 92.3
      }
    });
  },
  
  getRideAnalytics: (req, res) => {
    // Calculate average distance for sample rides
    const avgDistance = locationUtils.calculateDistance(40.7128, -74.0060, 40.7589, -73.9851);
    
    res.json({
      success: true,
      analytics: {
        avgRideDistance: avgDistance,
        ridesByHour: {
          '00:00': 12,
          '01:00': 8,
          '02:00': 5,
          '03:00': 3,
          '04:00': 2,
          '05:00': 4,
          '06:00': 15,
          '07:00': 42,
          '08:00': 68,
          '09:00': 52,
          '10:00': 45,
          '11:00': 38,
          '12:00': 41,
          '13:00': 39,
          '14:00': 44,
          '15:00': 51,
          '16:00': 62,
          '17:00': 78,
          '18:00': 85,
          '19:00': 72,
          '20:00': 65,
          '21:00': 58,
          '22:00': 47,
          '23:00': 28
        },
        ridesByDay: {
          'Monday': 520,
          'Tuesday': 480,
          'Wednesday': 510,
          'Thursday': 490,
          'Friday': 620,
          'Saturday': 750,
          'Sunday': 680
        },
        popularAreas: [
          { area: 'Downtown', rideCount: 320 },
          { area: 'Airport', rideCount: 280 },
          { area: 'University District', rideCount: 210 },
          { area: 'Business District', rideCount: 190 },
          { area: 'Shopping Mall', rideCount: 150 }
        ]
      }
    });
  },
  
  getUserGrowth: (req, res) => {
    res.json({
      success: true,
      growth: {
        riders: [
          { month: 'Jan', count: 850 },
          { month: 'Feb', count: 920 },
          { month: 'Mar', count: 980 },
          { month: 'Apr', count: 1050 },
          { month: 'May', count: 1120 },
          { month: 'Jun', count: 1250 }
        ],
        drivers: [
          { month: 'Jan', count: 210 },
          { month: 'Feb', count: 230 },
          { month: 'Mar', count: 250 },
          { month: 'Apr', count: 270 },
          { month: 'May', count: 290 },
          { month: 'Jun', count: 320 }
        ]
      }
    });
  }
};

// Get dashboard statistics
router.get('/dashboard', analyticsController.getDashboardStats);

// Get ride analytics
router.get('/rides', analyticsController.getRideAnalytics);

// Get user growth data
router.get('/growth', analyticsController.getUserGrowth);

module.exports = router;