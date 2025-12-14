const { Ride, User } = require('../models');
const createError = require('http-errors');

class RideService {
    /**
     * Create a new ride
     * @param {Object} rideData - Ride data
     * @returns {Promise<Object>} - Created ride
     */
    static async createRide(rideData) {
        try {
            const { riderId, pickupLocation, dropoffLocation, pickupAddress, dropoffAddress,
                vehicleType = 'uber-x', paymentMethod = 'credit_card', baseFare } = rideData;

            // Validate rider exists
            const rider = await User.findByPk(riderId);
            if (!rider) {
                throw createError(404, 'Rider not found');
            }

            // Create new ride
            const newRide = await Ride.create({
                riderId,
                status: 'requested',
                pickupLocation,
                dropoffLocation,
                pickupAddress,
                dropoffAddress,
                vehicleType,
                paymentMethod,
                baseFare,
                finalFare: baseFare // Initial fare estimate
            });

            return newRide;

        } catch (error) {
            console.error('Create ride service error:', error);
            throw error;
        }
    }

    /**
     * Get ride by ID
     * @param {string} rideId - Ride ID
     * @returns {Promise<Object>} - Ride data
     */
    static async getRideById(rideId) {
        try {
            const ride = await Ride.findByPk(rideId, {
                include: [
                    { model: User, as: 'rider', attributes: ['id', 'firstName', 'lastName', 'phoneNumber'] },
                    { model: User, as: 'driver', attributes: ['id', 'firstName', 'lastName', 'phoneNumber'] }
                ]
            });

            if (!ride) {
                throw createError(404, 'Ride not found');
            }

            return ride;

        } catch (error) {
            console.error('Get ride by ID service error:', error);
            throw error;
        }
    }

    /**
     * Get rides by rider ID
     * @param {string} riderId - Rider ID
     * @param {Object} options - Query options
     * @returns {Promise<Array>} - Array of rides
     */
    static async getRidesByRider(riderId, options = {}) {
        try {
            const { limit = 10, offset = 0, status } = options;

            const where = { riderId };
            if (status) {
                where.status = status;
            }

            const rides = await Ride.findAll({
                where,
                include: [
                    { model: User, as: 'driver', attributes: ['id', 'firstName', 'lastName'] }
                ],
                order: [['createdAt', 'DESC']],
                limit,
                offset
            });

            return rides;

        } catch (error) {
            console.error('Get rides by rider service error:', error);
            throw error;
        }
    }

    /**
     * Get rides by driver ID
     * @param {string} driverId - Driver ID
     * @param {Object} options - Query options
     * @returns {Promise<Array>} - Array of rides
     */
    static async getRidesByDriver(driverId, options = {}) {
        try {
            const { limit = 10, offset = 0, status } = options;

            const where = { driverId };
            if (status) {
                where.status = status;
            }

            const rides = await Ride.findAll({
                where,
                include: [
                    { model: User, as: 'rider', attributes: ['id', 'firstName', 'lastName'] }
                ],
                order: [['createdAt', 'DESC']],
                limit,
                offset
            });

            return rides;

        } catch (error) {
            console.error('Get rides by driver service error:', error);
            throw error;
        }
    }

    /**
     * Update ride status
     * @param {string} rideId - Ride ID
     * @param {string} status - New status
     * @param {Object} additionalData - Additional data to update
     * @returns {Promise<Object>} - Updated ride
     */
    static async updateRideStatus(rideId, status, additionalData = {}) {
        try {
            const ride = await Ride.findByPk(rideId);

            if (!ride) {
                throw createError(404, 'Ride not found');
            }

            // Validate status transition
            const validTransitions = {
                'requested': ['accepted', 'cancelled'],
                'accepted': ['in_progress', 'cancelled'],
                'in_progress': ['completed', 'cancelled'],
                'completed': [],
                'cancelled': []
            };

            if (!validTransitions[ride.status].includes(status)) {
                throw createError(400, `Invalid status transition from ${ride.status} to ${status}`);
            }

            // Update ride status and additional data
            const updateData = { status, ...additionalData };

            // Set timestamps based on status
            if (status === 'in_progress' && !ride.startedAt) {
                updateData.startedAt = new Date();
            } else if (status === 'completed' && !ride.completedAt) {
                updateData.completedAt = new Date();
            } else if (status === 'cancelled' && !ride.cancelledAt) {
                updateData.cancelledAt = new Date();
            }

            await ride.update(updateData);

            return ride;

        } catch (error) {
            console.error('Update ride status service error:', error);
            throw error;
        }
    }

    /**
     * Accept ride as driver
     * @param {string} rideId - Ride ID
     * @param {string} driverId - Driver ID
     * @returns {Promise<Object>} - Updated ride
     */
    static async acceptRide(rideId, driverId) {
        try {
            // Validate driver exists
            const driver = await User.findByPk(driverId);
            if (!driver || driver.userType !== 'driver') {
                throw createError(404, 'Driver not found');
            }

            // Update ride status and assign driver
            return this.updateRideStatus(rideId, 'accepted', { driverId });

        } catch (error) {
            console.error('Accept ride service error:', error);
            throw error;
        }
    }

    /**
     * Calculate ride fare
     * @param {string} rideId - Ride ID
     * @returns {Promise<Object>} - Updated ride with calculated fare
     */
    static async calculateFare(rideId) {
        try {
            const ride = await Ride.findByPk(rideId);

            if (!ride) {
                throw createError(404, 'Ride not found');
            }

            // Simple fare calculation based on vehicle type
            // In production, this would use distance, time, surge pricing, etc.
            const fareMultipliers = {
                'uber-x': 1.2,
                'uber-xl': 1.8,
                'comfort': 2.5,
                'black': 3.5,
                'pool': 0.8
            };

            const multiplier = fareMultipliers[ride.vehicleType] || 1.2;
            const calculatedFare = ride.baseFare * multiplier;

            await ride.update({ finalFare: calculatedFare });

            return ride;

        } catch (error) {
            console.error('Calculate fare service error:', error);
            throw error;
        }
    }
}

module.exports = RideService;