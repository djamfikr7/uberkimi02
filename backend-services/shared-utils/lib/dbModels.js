const { DataTypes } = require('sequelize');
const { sequelize } = require('./dbConfig');

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

// Driver Model
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
      model: 'users',
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
    defaultValue: 5.00
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

// Rider Model
const Rider = sequelize.define('Rider', {
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
      model: 'users',
      key: 'id'
    }
  },
  homeAddress: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  workAddress: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  riderRating: {
    type: DataTypes.DECIMAL(3, 2),
    allowNull: false,
    defaultValue: 5.00
  },
  totalRides: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0
  }
}, {
  tableName: 'riders',
  timestamps: true,
  underscored: true,
  paranoid: true
});

// Ride Model
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
      model: 'users',
      key: 'id'
    }
  },
  driverId: {
    type: DataTypes.UUID,
    allowNull: true,
    references: {
      model: 'users',
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
    type: DataTypes.ENUM('cash'),
    allowNull: false,
    defaultValue: 'cash'
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

// Payment Model
const Payment = sequelize.define('Payment', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  rideId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'rides',
      key: 'id'
    }
  },
  amount: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false
  },
  currency: {
    type: DataTypes.STRING,
    allowNull: false,
    defaultValue: 'USD'
  },
  paymentMethod: {
    type: DataTypes.ENUM('cash'),
    allowNull: false,
    defaultValue: 'cash'
  },
  status: {
    type: DataTypes.ENUM('pending', 'completed', 'failed', 'refunded'),
    allowNull: false,
    defaultValue: 'pending'
  },
  transactionId: {
    type: DataTypes.STRING,
    allowNull: true
  },
  processedAt: {
    type: DataTypes.DATE,
    allowNull: true
  }
}, {
  tableName: 'payments',
  timestamps: true,
  underscored: true,
  paranoid: true
});

// Location Model
const Location = sequelize.define('Location', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  userId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  latitude: {
    type: DataTypes.DECIMAL(10, 8),
    allowNull: false
  },
  longitude: {
    type: DataTypes.DECIMAL(11, 8),
    allowNull: false
  },
  address: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  locationType: {
    type: DataTypes.ENUM('current', 'home', 'work', 'favorite'),
    allowNull: false,
    defaultValue: 'current'
  },
  createdAt: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'locations',
  timestamps: false,
  underscored: true,
  paranoid: true
});

// Notification Model
const Notification = sequelize.define('Notification', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  userId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false
  },
  message: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  type: {
    type: DataTypes.ENUM('ride', 'payment', 'system', 'promotion'),
    allowNull: false
  },
  isRead: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false
  },
  relatedEntityId: {
    type: DataTypes.UUID,
    allowNull: true
  },
  relatedEntityType: {
    type: DataTypes.STRING,
    allowNull: true
  }
}, {
  tableName: 'notifications',
  timestamps: true,
  underscored: true,
  paranoid: true
});

// Rating Model
const Rating = sequelize.define('Rating', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  rideId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'rides',
      key: 'id'
    }
  },
  raterId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  ratedUserId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  rating: {
    type: DataTypes.DECIMAL(3, 2),
    allowNull: false
  },
  comment: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  ratingType: {
    type: DataTypes.ENUM('rider_to_driver', 'driver_to_rider'),
    allowNull: false
  }
}, {
  tableName: 'ratings',
  timestamps: true,
  underscored: true,
  paranoid: true
});

// Vehicle Model
const Vehicle = sequelize.define('Vehicle', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  driverId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'drivers',
      key: 'id'
    }
  },
  make: {
    type: DataTypes.STRING,
    allowNull: false
  },
  model: {
    type: DataTypes.STRING,
    allowNull: false
  },
  year: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  color: {
    type: DataTypes.STRING,
    allowNull: false
  },
  licensePlate: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  vehicleType: {
    type: DataTypes.ENUM('uber-x', 'uber-xl', 'comfort', 'black', 'pool'),
    allowNull: false,
    defaultValue: 'uber-x'
  },
  isApproved: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false
  }
}, {
  tableName: 'vehicles',
  timestamps: true,
  underscored: true,
  paranoid: true
});

// Message Model
const Message = sequelize.define('Message', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  rideId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'rides',
      key: 'id'
    }
  },
  senderId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  recipientId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  messageType: {
    type: DataTypes.ENUM('text', 'image', 'location'),
    allowNull: false,
    defaultValue: 'text'
  },
  isRead: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false
  }
}, {
  tableName: 'messages',
  timestamps: true,
  underscored: true,
  paranoid: true
});

// Define relationships
User.hasOne(Driver, { foreignKey: 'userId', as: 'driver' });
Driver.belongsTo(User, { foreignKey: 'userId', as: 'user' });

User.hasOne(Rider, { foreignKey: 'userId', as: 'rider' });
Rider.belongsTo(User, { foreignKey: 'userId', as: 'user' });

User.hasMany(Ride, { foreignKey: 'riderId', as: 'riderRides' });
Ride.belongsTo(User, { foreignKey: 'riderId', as: 'rider' });

User.hasMany(Ride, { foreignKey: 'driverId', as: 'driverRides' });
Ride.belongsTo(User, { foreignKey: 'driverId', as: 'driver' });

Ride.hasOne(Payment, { foreignKey: 'rideId', as: 'payment' });
Payment.belongsTo(Ride, { foreignKey: 'rideId', as: 'ride' });

User.hasMany(Location, { foreignKey: 'userId', as: 'locations' });
Location.belongsTo(User, { foreignKey: 'userId', as: 'user' });

User.hasMany(Notification, { foreignKey: 'userId', as: 'notifications' });
Notification.belongsTo(User, { foreignKey: 'userId', as: 'user' });

Ride.hasMany(Rating, { foreignKey: 'rideId', as: 'ratings' });
Rating.belongsTo(Ride, { foreignKey: 'rideId', as: 'ride' });

User.hasMany(Rating, { foreignKey: 'raterId', as: 'givenRatings' });
Rating.belongsTo(User, { foreignKey: 'raterId', as: 'rater' });

User.hasMany(Rating, { foreignKey: 'ratedUserId', as: 'receivedRatings' });
Rating.belongsTo(User, { foreignKey: 'ratedUserId', as: 'ratedUser' });

Driver.hasMany(Vehicle, { foreignKey: 'driverId', as: 'vehicles' });
Vehicle.belongsTo(Driver, { foreignKey: 'driverId', as: 'driver' });

// Message relationships
Ride.hasMany(Message, { foreignKey: 'rideId', as: 'messages' });
Message.belongsTo(Ride, { foreignKey: 'rideId', as: 'ride' });

User.hasMany(Message, { foreignKey: 'senderId', as: 'sentMessages' });
Message.belongsTo(User, { foreignKey: 'senderId', as: 'sender' });

User.hasMany(Message, { foreignKey: 'recipientId', as: 'receivedMessages' });
Message.belongsTo(User, { foreignKey: 'recipientId', as: 'recipient' });

// Export models
module.exports = {
  User,
  Driver,
  Rider,
  Ride,
  Payment,
  Location,
  Notification,
  Rating,
  Vehicle,
  Message
};