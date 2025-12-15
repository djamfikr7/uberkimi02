const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

// JWT utilities
const jwtUtils = {
  signToken: (payload, secret, expiresIn) => {
    // Add additional security claims
    const securePayload = {
      ...payload,
      iat: Math.floor(Date.now() / 1000),
      exp: Math.floor(Date.now() / 1000) + (expiresIn === '1h' ? 3600 : 86400)
    };
    
    return jwt.sign(securePayload, secret, { 
      expiresIn,
      algorithm: 'HS256'
    });
  },
  
  verifyToken: (token, secret) => {
    try {
      const decoded = jwt.verify(token, secret, { 
        algorithms: ['HS256'],
        clockTolerance: 30 // Allow 30 seconds clock drift
      });
      
      // Additional security checks
      if (!decoded.iat || !decoded.exp) {
        return null;
      }
      
      // Check if token is expired
      if (decoded.exp < Math.floor(Date.now() / 1000)) {
        return null;
      }
      
      return decoded;
    } catch (error) {
      console.error('JWT verification error:', error.message);
      return null;
    }
  },
  
  // Generate secure secret if not provided
  generateSecureSecret: () => {
    return require('crypto').randomBytes(64).toString('hex');
  }
};

// Password utilities
const passwordUtils = {
  hashPassword: async (password) => {
    const saltRounds = 10;
    return await bcrypt.hash(password, saltRounds);
  },
  
  comparePassword: async (password, hashedPassword) => {
    return await bcrypt.compare(password, hashedPassword);
  }
};

// Validation utilities
const validationUtils = {
  isValidEmail: (email) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  },
  
  isValidPhone: (phone) => {
    const phoneRegex = /^\+?[\d\s\-\(\)]{10,}$/;
    return phoneRegex.test(phone);
  },
  
  isValidPassword: (password) => {
    // At least 8 characters, one uppercase, one lowercase, one number
    const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$/;
    return passwordRegex.test(password);
  }
};

// Location utilities
const locationUtils = {
  calculateDistance: (lat1, lon1, lat2, lon2) => {
    // Haversine formula to calculate distance between two points
    const R = 6371; // Earth radius in kilometers
    const dLat = locationUtils.deg2rad(lat2 - lat1);
    const dLon = locationUtils.deg2rad(lon2 - lon1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(locationUtils.deg2rad(lat1)) * Math.cos(locationUtils.deg2rad(lat2)) *
      Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const d = R * c; // Distance in km
    return d;
  },
  
  deg2rad: (deg) => {
    return deg * (Math.PI / 180);
  }
};

// Export all utilities
module.exports = {
  jwtUtils,
  passwordUtils,
  validationUtils,
  locationUtils
};