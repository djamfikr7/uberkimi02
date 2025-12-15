const { body, validationResult } = require('express-validator');
const rateLimit = require('express-rate-limit');

/**
 * Input validation and sanitization utilities
 */

// Sanitize and validate user input
const sanitizeInput = (input) => {
  if (typeof input !== 'string') return input;
  
  return input
    .trim()
    .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '') // Remove script tags
    .replace(/<!--[\s\S]*?-->/g, '') // Remove HTML comments
    .replace(/[<>]/g, ''); // Remove angle brackets
};

// Validate and sanitize email
const validateEmail = (email) => {
  const sanitizedEmail = sanitizeInput(email);
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(sanitizedEmail) ? sanitizedEmail : null;
};

// Validate and sanitize phone number
const validatePhone = (phone) => {
  const sanitizedPhone = sanitizeInput(phone);
  const phoneRegex = /^\+?[\d\s\-\(\)]{10,}$/;
  return phoneRegex.test(sanitizedPhone) ? sanitizedPhone : null;
};

// Validate coordinates
const validateCoordinates = (lat, lng) => {
  const latNum = parseFloat(lat);
  const lngNum = parseFloat(lng);
  
  if (isNaN(latNum) || isNaN(lngNum)) {
    return null;
  }
  
  // Validate latitude range (-90 to 90)
  if (latNum < -90 || latNum > 90) {
    return null;
  }
  
  // Validate longitude range (-180 to 180)
  if (lngNum < -180 || lngNum > 180) {
    return null;
  }
  
  return { lat: latNum, lng: lngNum };
};

// Rate limiting configuration
const createRateLimiter = (windowMs, max, message) => {
  return rateLimit({
    windowMs,
    max,
    message: {
      success: false,
      message: message || 'Too many requests, please try again later.'
    },
    standardHeaders: true,
    legacyHeaders: false,
  });
};

// Global rate limiter
const globalLimiter = createRateLimiter(
  15 * 60 * 1000, // 15 minutes
  100, // 100 requests
  'Too many requests from this IP, please try again later.'
);

// Strict rate limiter for sensitive operations
const strictLimiter = createRateLimiter(
  15 * 60 * 1000, // 15 minutes
  5, // 5 requests
  'Too many attempts, please try again later.'
);

// Validate request data
const validateRequest = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      message: 'Validation failed',
      errors: errors.array()
    });
  }
  next();
};

// XSS protection middleware
const xssProtection = (req, res, next) => {
  // Sanitize query parameters
  if (req.query) {
    for (const key in req.query) {
      if (typeof req.query[key] === 'string') {
        req.query[key] = sanitizeInput(req.query[key]);
      }
    }
  }
  
  // Sanitize body parameters
  if (req.body) {
    for (const key in req.body) {
      if (typeof req.body[key] === 'string') {
        req.body[key] = sanitizeInput(req.body[key]);
      }
    }
  }
  
  next();
};

module.exports = {
  sanitizeInput,
  validateEmail,
  validatePhone,
  validateCoordinates,
  createRateLimiter,
  globalLimiter,
  strictLimiter,
  validateRequest,
  xssProtection
};