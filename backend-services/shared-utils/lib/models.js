// Shared data models for the Uber Clone project

// User model
class User {
  constructor(data) {
    this.id = data.id;
    this.email = data.email;
    this.firstName = data.firstName;
    this.lastName = data.lastName;
    this.phoneNumber = data.phoneNumber;
    this.role = data.role;
    this.status = data.status || 'active';
    this.createdAt = data.createdAt || new Date().toISOString();
    this.updatedAt = data.updatedAt || new Date().toISOString();
    
    if (data.role === 'driver' && data.vehicle) {
      this.vehicle = new Vehicle(data.vehicle);
    }
  }
  
  getFullName() {
    return `${this.firstName} ${this.lastName}`;
  }
  
  isActive() {
    return this.status === 'active';
  }
}

// Vehicle model
class Vehicle {
  constructor(data) {
    this.make = data.make;
    this.model = data.model;
    this.year = data.year;
    this.licensePlate = data.licensePlate;
    this.color = data.color;
  }
}

// Ride model
class Ride {
  constructor(data) {
    this.id = data.id;
    this.riderId = data.riderId;
    this.driverId = data.driverId;
    this.pickupAddress = data.pickupAddress;
    this.dropoffAddress = data.dropoffAddress;
    this.pickupLatitude = data.pickupLatitude;
    this.pickupLongitude = data.pickupLongitude;
    this.dropoffLatitude = data.dropoffLatitude;
    this.dropoffLongitude = data.dropoffLongitude;
    this.estimatedFare = data.estimatedFare;
    this.actualFare = data.actualFare;
    this.status = data.status;
    this.requestedAt = data.requestedAt;
    this.acceptedAt = data.acceptedAt;
    this.startedAt = data.startedAt;
    this.completedAt = data.completedAt;
    this.cancelledAt = data.cancelledAt;
    // Add location properties
    this.driverLocation = data.driverLocation;
    this.riderLocation = data.riderLocation;
  }
  
  // Add toJSON method to include location properties in JSON output
  toJSON() {
    return {
      id: this.id,
      riderId: this.riderId,
      driverId: this.driverId,
      pickupAddress: this.pickupAddress,
      dropoffAddress: this.dropoffAddress,
      pickupLatitude: this.pickupLatitude,
      pickupLongitude: this.pickupLongitude,
      dropoffLatitude: this.dropoffLatitude,
      dropoffLongitude: this.dropoffLongitude,
      estimatedFare: this.estimatedFare,
      actualFare: this.actualFare,
      status: this.status,
      requestedAt: this.requestedAt,
      acceptedAt: this.acceptedAt,
      startedAt: this.startedAt,
      completedAt: this.completedAt,
      cancelledAt: this.cancelledAt,
      driverLocation: this.driverLocation,
      riderLocation: this.riderLocation
    };
  }
  
  isInProgress() {
    return this.status === 'in_progress';
  }
  
  isCompleted() {
    return this.status === 'completed';
  }
  
  isCancelled() {
    return this.status === 'cancelled';
  }
}

// Export all models
module.exports = {
  User,
  Vehicle,
  Ride
};