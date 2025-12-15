const { Ride, User } = require('./dbModels');
const { Op } = require('sequelize');

// Fraud detection thresholds
const MAX_RIDES_PER_HOUR = 10;
const MIN_RIDE_DURATION_MINUTES = 2;
const MAX_RIDE_DURATION_HOURS = 24;
const SUSPICIOUS_CANCELLATION_RATE = 0.8; // 80% cancellation rate

class FraudDetectionService {
  /**
   * Check if a user is exhibiting suspicious ride request behavior
   */
  static async checkSuspiciousRideRequests(userId) {
    try {
      // Check if user has requested too many rides in the last hour
      const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000);
      const recentRides = await Ride.count({
        where: {
          riderId: userId,
          requestedAt: {
            [Op.gt]: oneHourAgo
          }
        }
      });

      if (recentRides > MAX_RIDES_PER_HOUR) {
        return {
          isSuspicious: true,
          reason: `User requested ${recentRides} rides in the last hour (limit: ${MAX_RIDES_PER_HOUR})`,
          severity: 'high'
        };
      }

      return { isSuspicious: false };
    } catch (error) {
      console.error('Error checking suspicious ride requests:', error);
      return { isSuspicious: false };
    }
  }

  /**
   * Check if a ride has suspicious characteristics
   */
  static async checkSuspiciousRide(rideId) {
    try {
      const ride = await Ride.findByPk(rideId);
      if (!ride) {
        return { isSuspicious: false };
      }

      // Check for extremely short rides
      if (ride.status === 'completed' && ride.startedAt && ride.completedAt) {
        const durationMinutes = (new Date(ride.completedAt) - new Date(ride.startedAt)) / (1000 * 60);
        if (durationMinutes < MIN_RIDE_DURATION_MINUTES) {
          return {
            isSuspicious: true,
            reason: `Ride duration (${durationMinutes.toFixed(1)} minutes) is suspiciously short (minimum: ${MIN_RIDE_DURATION_MINUTES} minutes)`,
            severity: 'medium'
          };
        }
      }

      // Check for extremely long rides
      if (ride.status === 'completed' && ride.startedAt && ride.completedAt) {
        const durationHours = (new Date(ride.completedAt) - new Date(ride.startedAt)) / (1000 * 60 * 60);
        if (durationHours > MAX_RIDE_DURATION_HOURS) {
          return {
            isSuspicious: true,
            reason: `Ride duration (${durationHours.toFixed(1)} hours) is suspiciously long (maximum: ${MAX_RIDE_DURATION_HOURS} hours)`,
            severity: 'high'
          };
        }
      }

      return { isSuspicious: false };
    } catch (error) {
      console.error('Error checking suspicious ride:', error);
      return { isSuspicious: false };
    }
  }

  /**
   * Check if a user has a high cancellation rate
   */
  static async checkHighCancellationRate(userId) {
    try {
      // Get total rides and cancelled rides for the user in the last 24 hours
      const twentyFourHoursAgo = new Date(Date.now() - 24 * 60 * 60 * 1000);
      
      const totalRides = await Ride.count({
        where: {
          riderId: userId,
          requestedAt: {
            [Op.gt]: twentyFourHoursAgo
          }
        }
      });

      if (totalRides === 0) {
        return { isSuspicious: false };
      }

      const cancelledRides = await Ride.count({
        where: {
          riderId: userId,
          status: 'cancelled',
          requestedAt: {
            [Op.gt]: twentyFourHoursAgo
          }
        }
      });

      const cancellationRate = cancelledRides / totalRides;
      
      if (cancellationRate > SUSPICIOUS_CANCELLATION_RATE) {
        return {
          isSuspicious: true,
          reason: `High cancellation rate: ${(cancellationRate * 100).toFixed(1)}% (threshold: ${(SUSPICIOUS_CANCELLATION_RATE * 100)}%)`,
          severity: 'high'
        };
      }

      return { isSuspicious: false };
    } catch (error) {
      console.error('Error checking cancellation rate:', error);
      return { isSuspicious: false };
    }
  }

  /**
   * Flag a user for review based on suspicious activity
   */
  static async flagUserForReview(userId, reason, severity) {
    try {
      // In a real implementation, this would:
      // 1. Log the suspicious activity to a database
      // 2. Notify administrators
      // 3. Potentially temporarily suspend the user's account
      // 4. Trigger additional verification steps
      
      console.warn(`🚩 User ${userId} flagged for review - ${reason} (Severity: ${severity})`);
      
      // For now, we'll just log it
      return {
        flagged: true,
        message: `User flagged for review: ${reason}`
      };
    } catch (error) {
      console.error('Error flagging user for review:', error);
      return {
        flagged: false,
        error: 'Failed to flag user for review'
      };
    }
  }

  /**
   * Run comprehensive fraud checks on a user
   */
  static async runFraudChecks(userId) {
    try {
      const checks = [
        this.checkSuspiciousRideRequests(userId),
        this.checkHighCancellationRate(userId)
      ];

      const results = await Promise.all(checks);
      
      const suspiciousResults = results.filter(result => result.isSuspicious);
      
      if (suspiciousResults.length > 0) {
        // Combine reasons for reporting
        const combinedReason = suspiciousResults.map(r => r.reason).join('; ');
        const highestSeverity = suspiciousResults.some(r => r.severity === 'high') ? 'high' : 'medium';
        
        return await this.flagUserForReview(userId, combinedReason, highestSeverity);
      }

      return { flagged: false };
    } catch (error) {
      console.error('Error running fraud checks:', error);
      return { flagged: false, error: 'Failed to run fraud checks' };
    }
  }
}

module.exports = FraudDetectionService;