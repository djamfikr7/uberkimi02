const { User, Driver } = require('../models');
const createError = require('http-errors');

class DriverService {
    /**
     * Register as driver
     * @param {string} userId - User ID
     * @param {Object} driverData - Driver registration data
     * @returns {Promise<Object>} - Created driver
     */
    static async registerAsDriver(userId, driverData) {
        try {
            // Check if user exists and is not already a driver
            const user = await User.findByPk(userId);
            if (!user) {
                throw createError(404, 'User not found');
            }

            // Check if user is already a driver
            const existingDriver = await Driver.findOne({ where: { userId } });
            if (existingDriver) {
                throw createError(409, 'User is already registered as a driver');
            }

            // Create driver profile
            const newDriver = await Driver.create({
                userId,
                ...driverData,
                driverRating: 5.0,
                totalRides: 0,
                isOnline: false
            });

            return newDriver;

        } catch (error) {
            console.error('Register as driver service error:', error);
            throw error;
        }
    }

    /**
     * Get driver profile
     * @param {string} userId - User ID
     * @returns {Promise<Object>} - Driver profile
     */
    static async getDriverProfile(userId) {
        try {
            const driver = await Driver.findOne({
                where: { userId },
                include: [
                    { model: User, as: 'user', attributes: ['id', 'firstName', 'lastName', 'email', 'phoneNumber'] }
                ]
            });

            if (!driver) {
                throw createError(404, 'Driver profile not found');
            }

            return driver;

        } catch (error) {
            console.error('Get driver profile service error:', error);
            throw error;
        }
    }

    /**
     * Update driver profile
     * @param {string} userId - User ID
     * @param {Object} updateData - Data to update
     * @returns {Promise<Object>} - Updated driver profile
     */
    static async updateDriverProfile(userId, updateData) {
        try {
            const driver = await Driver.findOne({ where: { userId } });

            if (!driver) {
                throw createError(404, 'Driver profile not found');
            }

            await driver.update(updateData);

            return driver;

        } catch (error) {
            console.error('Update driver profile service error:', error);
            throw error;
        }
    }

    /**
     * Update driver online status
     * @param {string} userId - User ID
     * @param {boolean} isOnline - Online status
     * @returns {Promise<Object>} - Updated driver profile
     */
    static async updateDriverOnlineStatus(userId, isOnline) {
        try {
            const driver = await Driver.findOne({ where: { userId } });

            if (!driver) {
                throw createError(404, 'Driver profile not found');
            }

            await driver.update({ isOnline });

            return driver;

        } catch (error) {
            console.error('Update driver online status service error:', error);
            throw error;
        }
    }

    /**
     * Update driver location
     * @param {string} userId - User ID
     * @param {Object} location - Location data
     * @returns {Promise<Object>} - Updated driver profile
     */
    static async updateDriverLocation(userId, location) {
        try {
            const driver = await Driver.findOne({ where: { userId } });

            if (!driver) {
                throw createError(404, 'Driver profile not found');
            }

            await driver.update({ currentLocation: location });

            return driver;

        } catch (error) {
            console.error('Update driver location service error:', error);
            throw error;
        }
    }

    /**
     * Get available drivers near location
     * @param {Object} location - Center location
     * @param {number} radius - Search radius in meters
     * @param {number} limit - Maximum number of drivers to return
     * @returns {Promise<Array>} - Array of available drivers
     */
    static async getAvailableDriversNearLocation(location, radius = 5000, limit = 10) {
        try {
            // In a real implementation, this would use spatial queries
            // For now, return online drivers
            const drivers = await Driver.findAll({
                where: { isOnline: true },
                include: [
                    { model: User, as: 'user', attributes: ['id', 'firstName', 'lastName'] }
                ],
                limit
            });

            return drivers;

        } catch (error) {
            console.error('Get available drivers service error:', error);
            throw error;
        }
    }

    /**
     * Update driver rating
     * @param {string} driverId - Driver ID
     * @param {number} rating - New rating (1-5)
     * @returns {Promise<Object>} - Updated driver profile
     */
    static async updateDriverRating(driverId, rating) {
        try {
            const driver = await Driver.findByPk(driverId);

            if (!driver) {
                throw createError(404, 'Driver not found');
            }

            // Calculate new average rating
            const totalRides = driver.totalRides + 1;
            const currentRating = driver.driverRating;
            const newRating = ((currentRating * driver.totalRides) + rating) / totalRides;

            await driver.update({
                driverRating: newRating,
                totalRides: totalRides
            });

            return driver;

        } catch (error) {
            console.error('Update driver rating service error:', error);
            throw error;
        }
    }
}

module.exports = DriverService;