// Shared utilities and models for the Uber Clone project

module.exports = {
  // Export all utilities
  ...require('./utils'),
  
  // Export authentication middleware
  ...require('./authMiddleware'),
  
  // Export database configuration
  ...require('./dbConfig'),
  
  // Export database models
  ...require('./dbModels'),
  
  // Export all models
  ...require('./models'),
  
  // Export fraud detection service
  fraudDetection: require('./fraudDetection'),
  
  // Export security utilities
  ...require('./securityUtils'),
  
  // Export security configuration
  ...require('./securityConfig')
};