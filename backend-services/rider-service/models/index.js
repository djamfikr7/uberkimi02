const { sequelize, User, Driver, Rider, Ride, Payment, Location, Notification, Rating, Vehicle } = require('@uber-clone/shared-utils');

// Export models
module.exports = {
  sequelize,
  User,
  Driver,
  Rider,
  Ride,
  Payment,
  Location,
  Notification,
  Rating,
  Vehicle
};