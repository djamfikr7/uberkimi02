/**
 * Security configuration for the Uber Clone application
 * Contains security policies, constants, and configuration settings
 */

// Security constants
const SECURITY_CONSTANTS = {
  // Password requirements
  PASSWORD_MIN_LENGTH: 8,
  PASSWORD_MAX_LENGTH: 128,
  
  // Token expiration times
  ACCESS_TOKEN_EXPIRY: '1h',
  REFRESH_TOKEN_EXPIRY: '7d',
  
  // Rate limiting
  RATE_LIMIT_WINDOW_MS: 15 * 60 * 1000, // 15 minutes
  RATE_LIMIT_MAX_REQUESTS: 100,
  RATE_LIMIT_AUTH_MAX_REQUESTS: 5,
  
  // Session management
  SESSION_TIMEOUT: 24 * 60 * 60 * 1000, // 24 hours
  
  // Data validation
  MAX_STRING_LENGTH: 1000,
  MAX_TEXT_LENGTH: 10000,
  
  // File upload limits
  MAX_FILE_SIZE: 5 * 1024 * 1024, // 5MB
  ALLOWED_FILE_TYPES: ['image/jpeg', 'image/png', 'image/gif'],
  
  // Security headers
  SECURITY_HEADERS: {
    'X-Content-Type-Options': 'nosniff',
    'X-Frame-Options': 'DENY',
    'X-XSS-Protection': '1; mode=block',
    'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
    'Referrer-Policy': 'strict-origin-when-cross-origin',
    'Permissions-Policy': 'geolocation=(), microphone=(), camera=()'
  }
};

// CORS configuration
const CORS_CONFIG = {
  origin: process.env.ALLOWED_ORIGINS?.split(',') || [
    'http://localhost:3000',
    'http://localhost:3001',
    'http://localhost:3002'
  ],
  credentials: true,
  optionsSuccessStatus: 200
};

// Helmet configuration
const HELMET_CONFIG = {
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "https:"],
      scriptSrc: ["'self'"],
      connectSrc: ["'self'", "ws:", "wss:"],
      fontSrc: ["'self'", "https:", "data:"],
      objectSrc: ["'none'"],
      mediaSrc: ["'self'"],
      frameSrc: ["'none'"]
    }
  },
  dnsPrefetchControl: {
    allow: false
  },
  frameguard: {
    action: 'deny'
  },
  hidePoweredBy: true,
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  },
  ieNoOpen: true,
  noSniff: true,
  referrerPolicy: {
    policy: 'strict-origin-when-cross-origin'
  },
  xssFilter: true
};

// JWT configuration
const JWT_CONFIG = {
  ALGORITHM: 'HS256',
  ACCESS_TOKEN_SECRET: process.env.JWT_SECRET || require('crypto').randomBytes(64).toString('hex'),
  REFRESH_TOKEN_SECRET: process.env.JWT_REFRESH_SECRET || require('crypto').randomBytes(64).toString('hex'),
  CLOCK_TOLERANCE: 30, // seconds
  ISSUER: 'uber-clone',
  AUDIENCE: 'uber-clone-users'
};

// Input validation rules
const VALIDATION_RULES = {
  EMAIL: {
    REGEX: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
    MAX_LENGTH: 254
  },
  PHONE: {
    REGEX: /^\+?[\d\s\-\(\)]{10,}$/,
    MAX_LENGTH: 20
  },
  NAME: {
    MIN_LENGTH: 1,
    MAX_LENGTH: 50,
    REGEX: /^[a-zA-Z\s\-']+$/ // Allow letters, spaces, hyphens, and apostrophes
  },
  PASSWORD: {
    MIN_LENGTH: 8,
    MAX_LENGTH: 128,
    REQUIREMENTS: {
      LOWERCASE: /[a-z]/,
      UPPERCASE: /[A-Z]/,
      NUMBER: /\d/,
      SPECIAL: /[@$!%*?&]/
    }
  },
  COORDINATES: {
    LATITUDE_MIN: -90,
    LATITUDE_MAX: 90,
    LONGITUDE_MIN: -180,
    LONGITUDE_MAX: 180
  }
};

// Security logging configuration
const SECURITY_LOGGING = {
  ENABLED: true,
  LEVEL: process.env.SECURITY_LOG_LEVEL || 'info',
  MAX_LOG_SIZE: '100m',
  RETENTION_DAYS: 30
};

module.exports = {
  SECURITY_CONSTANTS,
  CORS_CONFIG,
  HELMET_CONFIG,
  JWT_CONFIG,
  VALIDATION_RULES,
  SECURITY_LOGGING
};