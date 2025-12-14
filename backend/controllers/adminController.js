// Get dashboard stats
const getDashboardStats = async (req, res, next) => {
  try {
    // Mock response for demo
    const mockStats = {
      activeUsers: 1245,
      activeDrivers: 456,
      dailyRides: 892,
      dailyRevenue: 12450.00,
      averageRating: 4.7,
      completionRate: 95.5,
      averageWaitTime: 2.5
    };

    res.json({
      success: true,
      message: 'Dashboard stats retrieved successfully',
      data: {
        stats: mockStats
      }
    });
  } catch (error) {
    console.error('Get dashboard stats error:', error);
    next(error);
  }
};

// Get all users
const getAllUsers = async (req, res, next) => {
  try {
    const { page = 1, limit = 10, type } = req.query;

    // Mock response for demo
    const mockUsers = [
      {
        id: 'user_1',
        email: 'user1@example.com',
        firstName: 'John',
        lastName: 'Doe',
        userType: 'rider',
        phoneNumber: '+1234567890',
        status: 'active',
        createdAt: new Date(Date.now() - 86400000).toISOString()
      },
      {
        id: 'user_2',
        email: 'user2@example.com',
        firstName: 'Jane',
        lastName: 'Smith',
        userType: 'driver',
        phoneNumber: '+1987654321',
        status: 'active',
        createdAt: new Date(Date.now() - 172800000).toISOString()
      }
    ];

    res.json({
      success: true,
      message: 'Users retrieved successfully',
      data: {
        users: mockUsers,
        total: mockUsers.length,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(mockUsers.length / limit)
      }
    });
  } catch (error) {
    console.error('Get all users error:', error);
    next(error);
  }
};

// Get all rides
const getAllRides = async (req, res, next) => {
  try {
    const { page = 1, limit = 10, status } = req.query;

    // Mock response for demo
    const mockRides = [
      {
        id: 'ride_1',
        riderId: 'user_1',
        driverId: 'driver_1',
        status: 'completed',
        pickupLocation: '123 Main St',
        dropoffLocation: '456 Oak Ave',
        distanceKm: 5.2,
        fare: 15.50,
        vehicleType: 'UberX',
        paymentMethod: 'credit_card',
        createdAt: new Date(Date.now() - 86400000).toISOString()
      },
      {
        id: 'ride_2',
        riderId: 'user_2',
        driverId: 'driver_2',
        status: 'in_progress',
        pickupLocation: '789 Pine Rd',
        dropoffLocation: '321 Elm Blvd',
        distanceKm: 12.8,
        fare: 28.75,
        vehicleType: 'Comfort',
        paymentMethod: 'credit_card',
        createdAt: new Date(Date.now() - 3600000).toISOString()
      }
    ];

    res.json({
      success: true,
      message: 'Rides retrieved successfully',
      data: {
        rides: mockRides,
        total: mockRides.length,
        page: parseInt(page),
        limit: parseInt(limit),
        totalPages: Math.ceil(mockRides.length / limit)
      }
    });
  } catch (error) {
    console.error('Get all rides error:', error);
    next(error);
  }
};

// Get system health
const getSystemHealth = async (req, res, next) => {
  try {
    // Mock response for demo
    const mockHealth = {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      services: {
        database: 'connected',
        cache: 'connected',
        paymentGateway: 'connected',
        notificationService: 'connected'
      },
      metrics: {
        responseTime: '45ms',
        errorRate: '0.1%',
        uptime: '99.9%'
      }
    };

    res.json({
      success: true,
      message: 'System health retrieved successfully',
      data: {
        health: mockHealth
      }
    });
  } catch (error) {
    console.error('Get system health error:', error);
    next(error);
  }
};

module.exports = {
  getDashboardStats,
  getAllUsers,
  getAllRides,
  getSystemHealth
};