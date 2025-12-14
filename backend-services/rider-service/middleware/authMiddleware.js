const jwt = require('jsonwebtoken');
const createError = require('http-errors');

// Load environment variables
require('dotenv').config();

// Authentication middleware
const authMiddleware = (req, res, next) => {
  try {
    // Get token from header
    const token = req.header('Authorization')?.replace('Bearer ', '');

    if (!token) {
      throw createError(401, 'Authentication required');
    }

    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    if (!decoded) {
      throw createError(401, 'Invalid token');
    }

    // Attach user to request
    req.user = decoded;

    // Proceed to next middleware
    next();

  } catch (error) {
    console.error('Authentication error:', error);
    
    if (error.name === 'JsonWebTokenError') {
      next(createError(401, 'Invalid token'));
    } else if (error.name === 'TokenExpiredError') {
      next(createError(401, 'Token expired'));
    } else {
      next(createError(401, 'Authentication failed'));
    }
  }
};

// Role-based authorization middleware
const authorize = (roles = []) => {
  return (req, res, next) => {
    try {
      const user = req.user;

      if (!user) {
        throw createError(401, 'Authentication required');
      }

      if (roles.length && !roles.includes(user.userType)) {
        throw createError(403, 'Insufficient permissions');
      }

      // Proceed to next middleware
      next();

    } catch (error) {
      console.error('Authorization error:', error);
      next(error);
    }
  };
};

// Demo auth middleware (bypass for development)
const demoAuthMiddleware = (req, res, next) => {
  try {
    // Get token from header
    const token = req.header('Authorization')?.replace('Bearer ', '');

    // For demo purposes, allow demo tokens
    if (token && token.startsWith('demo_')) {
      const userType = token.split('_')[1];
      req.user = {
        id: `demo_${userType}_123`,
        email: `${userType}@demo.com`,
        userType: userType,
        firstName: 'Demo',
        lastName: userType.charAt(0).toUpperCase() + userType.slice(1)
      };
      return next();
    }

    // Otherwise use normal auth
    if (!token) {
      throw createError(401, 'Authentication required');
    }

    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    if (!decoded) {
      throw createError(401, 'Invalid token');
    }

    // Attach user to request
    req.user = decoded;

    // Proceed to next middleware
    next();

  } catch (error) {
    console.error('Authentication error:', error);
    
    if (error.name === 'JsonWebTokenError') {
      next(createError(401, 'Invalid token'));
    } else if (error.name === 'TokenExpiredError') {
      next(createError(401, 'Token expired'));
    } else {
      next(createError(401, 'Authentication failed'));
    }
  }
};

module.exports = {
  authMiddleware,
  authorize,
  demoAuthMiddleware
};