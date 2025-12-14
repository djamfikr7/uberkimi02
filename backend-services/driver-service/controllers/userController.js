// Get user profile
const getProfile = async (req, res, next) => {
  try {
    const user = req.user;
    res.json({
      success: true,
      message: 'User profile retrieved successfully',
      data: {
        user: {
          id: user.id,
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          userType: user.userType,
          phoneNumber: user.phoneNumber || ''
        }
      }
    });
  } catch (error) {
    console.error('Get profile error:', error);
    next(error);
  }
};

// Update user profile
const updateProfile = async (req, res, next) => {
  try {
    const user = req.user;
    const { firstName, lastName, phoneNumber } = req.body;

    res.json({
      success: true,
      message: 'User profile updated successfully',
      data: {
        user: {
          id: user.id,
          email: user.email,
          firstName: firstName || user.firstName,
          lastName: lastName || user.lastName,
          userType: user.userType,
          phoneNumber: phoneNumber || user.phoneNumber || ''
        }
      }
    });
  } catch (error) {
    console.error('Update profile error:', error);
    next(error);
  }
};

// Get user rides
const getUserRides = async (req, res, next) => {
  try {
    const user = req.user;

    // Mock data for demo
    const mockRides = [
      {
        id: 'ride_1',
        status: 'completed',
        pickupLocation: '123 Main St',
        dropoffLocation: '456 Oak Ave',
        distanceKm: 5.2,
        fare: 15.50,
        vehicleType: 'UberX',
        createdAt: new Date(Date.now() - 86400000).toISOString()
      },
      {
        id: 'ride_2',
        status: 'completed',
        pickupLocation: '789 Pine Rd',
        dropoffLocation: '321 Elm Blvd',
        distanceKm: 12.8,
        fare: 28.75,
        vehicleType: 'Comfort',
        createdAt: new Date(Date.now() - 172800000).toISOString()
      }
    ];

    res.json({
      success: true,
      message: 'User rides retrieved successfully',
      data: {
        rides: mockRides,
        total: mockRides.length
      }
    });
  } catch (error) {
    console.error('Get user rides error:', error);
    next(error);
  }
};

// Get user payments
const getUserPayments = async (req, res, next) => {
  try {
    const user = req.user;

    // Mock data for demo
    const mockPayments = [
      {
        id: 'payment_1',
        rideId: 'ride_1',
        amount: 15.50,
        method: 'credit_card',
        status: 'completed',
        createdAt: new Date(Date.now() - 86400000).toISOString()
      },
      {
        id: 'payment_2',
        rideId: 'ride_2',
        amount: 28.75,
        method: 'credit_card',
        status: 'completed',
        createdAt: new Date(Date.now() - 172800000).toISOString()
      }
    ];

    res.json({
      success: true,
      message: 'User payments retrieved successfully',
      data: {
        payments: mockPayments,
        total: mockPayments.length
      }
    });
  } catch (error) {
    console.error('Get user payments error:', error);
    next(error);
  }
};

module.exports = {
  getProfile,
  updateProfile,
  getUserRides,
  getUserPayments
};