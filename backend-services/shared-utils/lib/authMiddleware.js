const { jwtUtils } = require('./utils');

/**
 * Authentication middleware for all services
 * Verifies JWT tokens and attaches user information to the request
 */
const authenticate = (allowedRoles = []) => {
  return (req, res, next) => {
    try {
      // Security check: Block if request is too large
      if (req.headers['content-length'] && parseInt(req.headers['content-length']) > 1000000) { // 1MB limit
        return res.status(413).json({
          success: false,
          message: 'Request entity too large.'
        });
      }

      // Get token from header
      const authHeader = req.headers.authorization;
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({
          success: false,
          message: 'Access denied. No token provided.'
        });
      }

      const token = authHeader.substring(7); // Remove 'Bearer ' prefix
      
      // Security check: Validate token format
      if (token.length < 50) { // JWT tokens are typically much longer
        return res.status(401).json({
          success: false,
          message: 'Invalid token format.'
        });
      }
      
      // Verify token
      const decoded = jwtUtils.verifyToken(token, process.env.JWT_SECRET || jwtUtils.generateSecureSecret());
      
      if (!decoded) {
        return res.status(401).json({
          success: false,
          message: 'Invalid or expired token.'
        });
      }
      
      // Additional security checks
      // Check if token was issued recently (prevent replay attacks)
      const issuedAt = decoded.iat;
      if (!issuedAt || (Date.now() / 1000 - issuedAt) > (7 * 24 * 60 * 60)) { // 7 days
        return res.status(401).json({
          success: false,
          message: 'Token expired or invalid issuance time.'
        });
      }
      
      // Check role-based access if roles are specified
      if (allowedRoles.length > 0 && !allowedRoles.includes(decoded.role)) {
        return res.status(403).json({
          success: false,
          message: 'Access denied. Insufficient permissions.'
        });
      }
      
      // Attach user info to request
      req.user = decoded;
      next();
    } catch (error) {
      console.error('Authentication error:', error);
      res.status(500).json({
        success: false,
        message: 'Authentication error.',
        error: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
      });
    }
  };
};

module.exports = {
  authenticate
};