const { Sequelize, DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

// User Model
const User = sequelize.define('User', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true
    }
  },
  passwordHash: {
    type: DataTypes.STRING,
    allowNull: false
  },
  firstName: {
    type: DataTypes.STRING,
    allowNull: false
  },
  lastName: {
    type: DataTypes.STRING,
    allowNull: false
  },
  phoneNumber: {
    type: DataTypes.STRING,
    allowNull: true
  },
  profilePictureUrl: {
    type: DataTypes.STRING,
    allowNull: true
  },
  userType: {
    type: DataTypes.ENUM('rider', 'driver', 'admin'),
    allowNull: false,
    defaultValue: 'rider'
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: true
  },
  lastLogin: {
    type: DataTypes.DATE,
    allowNull: true
  }
}, {
  tableName: 'users',
  timestamps: true,
  underscored: true,
  paranoid: true
});

// Ride Model (basic structure)
const Ride = sequelize.define('Ride', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  riderId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: User,
      key: 'id'
    }
  },
  driverId: {
    type: DataTypes.UUID,
    allowNull: true,
    references: {
      model: User,
      key: 'id'
    }
  },
  status: {
    type: DataTypes.ENUM('requested', 'accepted', 'in_progress', 'completed', 'cancelled'),
    allowNull: false,
    defaultValue: 'requested'
  },
  pickupLocation: {
    type: DataTypes.GEOMETRY('POINT'),
    allowNull: false
  },
  dropoffLocation: {
    type: DataTypes.GEOMETRY('POINT'),
    allowNull: false
  },
  pickupAddress: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  dropoffAddress: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  distanceKm: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true
  },
  durationMinutes: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  baseFare: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false
  },
  finalFare: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true
  },
  vehicleType: {
    type: DataTypes.ENUM('uber-x', 'uber-xl', 'comfort', 'black', 'pool'),
    allowNull: false,
    defaultValue: 'uber-x'
  },
  paymentMethod: {
    type: DataTypes.ENUM('credit_card', 'cash', 'wallet', 'paypal'),
    allowNull: false,
    defaultValue: 'credit_card'
  },
  paymentStatus: {
    type: DataTypes.ENUM('pending', 'completed', 'failed', 'refunded'),
    allowNull: false,
    defaultValue: 'pending'
  },
  rideRatingRider: {
    type: DataTypes.DECIMAL(3, 2),
    allowNull: true
  },
  rideRatingDriver: {
    type: DataTypes.DECIMAL(3, 2),
    allowNull: true
  },
  riderFeedback: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  driverFeedback: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  startedAt: {
    type: DataTypes.DATE,
    allowNull: true
  },
  completedAt: {
    type: DataTypes.DATE,
    allowNull: true
  },
  cancelledAt: {
    type: DataTypes.DATE,
    allowNull: true
  }
}, {
  tableName: 'rides',
  timestamps: true,
  underscored: true,
  paranoid: true
});

// Driver Model (basic structure)
const Driver = sequelize.define('Driver', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  userId: {
    type: DataTypes.UUID,
    allowNull: false,
    unique: true,
    references: {
      model: User,
      key: 'id'
    }
  },
  licenseNumber: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  vehicleType: {
    type: DataTypes.ENUM('uber-x', 'uber-xl', 'comfort', 'black', 'pool'),
    allowNull: false,
    defaultValue: 'uber-x'
  },
  vehicleMake: {
    type: DataTypes.STRING,
    allowNull: false
  },
  vehicleModel: {
    type: DataTypes.STRING,
    allowNull: false
  },
  vehicleYear: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  vehicleColor: {
    type: DataTypes.STRING,
    allowNull: false
  },
  licensePlate: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  driverRating: {
    type: DataTypes.DECIMAL(3, 2),
    allowNull: false,
    defaultValue: 5.0
  },
  totalRides: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0
  },
  isOnline: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false
  },
  currentLocation: {
    type: DataTypes.GEOMETRY('POINT'),
    allowNull: true
  }
}, {
  tableName: 'drivers',
  timestamps: true,
  underscored: true,
  paranoid: true
});

// Define relationships
User.hasOne(Driver, { foreignKey: 'userId', as: 'driver' });
Driver.belongsTo(User, { foreignKey: 'userId', as: 'user' });

User.hasMany(Ride, { foreignKey: 'riderId', as: 'riderRides' });
User.hasMany(Ride, { foreignKey: 'driverId', as: 'driverRides' });
Ride.belongsTo(User, { foreignKey: 'riderId', as: 'rider' });
Ride.belongsTo(User, { foreignKey: 'driverId', as: 'driver' });

// Export models
module.exports = {
  sequelize,
  User,
  Ride,
  Driver
};