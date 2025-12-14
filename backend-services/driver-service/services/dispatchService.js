const { User, Driver, Ride } = require('../models');
const createError = require('http-errors');
const { io } = require('../server');

class DispatchService {
    /**
     * Find nearby available drivers and notify them of a new ride request
     * @param {Object} ride - Ride object
     * @returns {Promise<Array>} - Array of notified driver IDs
     */
    static async notifyNearbyDrivers(ride) {
        try {
            console.log(`🔍 Looking for nearby drivers for ride ${ride.id}`);
            
            // For simplicity in this implementation, we'll notify all online drivers
            // In a production system, this would use spatial indexing (like S2) to find nearby drivers
            
            const onlineDrivers = await Driver.findAll({
                where: { isOnline: true },
                include: [{
                    model: User,
                    attributes: ['id', 'email', 'firstName', 'lastName']
                }]
            });
            
            console.log(`📡 Found ${onlineDrivers.length} online drivers`);
            
            const notifiedDrivers = [];
            
            // Notify each online driver
            for (const driver of onlineDrivers) {
                try {
                    // Emit ride notification to all connected clients
                    // In a real system, we would emit to specific driver's socket
                    io.emit('new_ride_request', {
                        rideId: ride.id,
                        pickupLocation: ride.pickupLocation,
                        dropoffLocation: ride.dropoffLocation,
                        pickupAddress: ride.pickupAddress,
                        dropoffAddress: ride.dropoffAddress,
                        baseFare: ride.baseFare,
                        vehicleType: ride.vehicleType,
                        createdAt: ride.createdAt
                    });
                    
                    notifiedDrivers.push(driver.userId);
                    console.log(`🔔 Notified driver ${driver.userId} of new ride request`);
                } catch (error) {
                    console.error(`❌ Error notifying driver ${driver.userId}:`, error.message);
                }
            }
            
            // Update ride with notified drivers
            if (notifiedDrivers.length > 0) {
                await ride.update({
                    notifiedDrivers: notifiedDrivers
                });
            }
            
            return notifiedDrivers;
            
        } catch (error) {
            console.error('Dispatch service error:', error);
            throw error;
        }
    }
    
    /**
     * Mark driver as online/offline
     * @param {string} driverId - Driver ID
     * @param {boolean} isOnline - Online status
     * @returns {Promise<Object>} - Updated driver
     */
    static async updateDriverStatus(driverId, isOnline) {
        try {
            const driver = await Driver.findOne({ where: { userId: driverId } });
            if (!driver) {
                throw createError(404, 'Driver not found');
            }
            
            await driver.update({ isOnline });
            
            console.log(`🚗 Driver ${driverId} is now ${isOnline ? 'online' : 'offline'}`);
            
            return driver;
        } catch (error) {
            console.error('Update driver status error:', error);
            throw error;
        }
    }
    
    /**
     * Get nearby online drivers count
     * @param {Object} location - Location coordinates {lat, lng}
     * @returns {Promise<number>} - Count of nearby online drivers
     */
    static async getNearbyDriversCount(location) {
        try {
            // For simplicity, return count of all online drivers
            // In a production system, this would filter by proximity
            const count = await Driver.count({
                where: { isOnline: true }
            });
            
            return count;
        } catch (error) {
            console.error('Get nearby drivers count error:', error);
            throw error;
        }
    }
}

module.exports = DispatchService;