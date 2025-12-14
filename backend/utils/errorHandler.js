const createError = require('http-errors');

// Error handling middleware
const errorHandler = (err, req, res, next) => {
  // Set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // Log error
  console.error('❌ Error:', err);

  // Handle specific error types
  if (err.name === 'ValidationError') {
    return res.status(400).json({
      error: 'VALIDATION_ERROR',
      message: err.message,
      details: err.details || []
    });
  }

  if (err.name === 'UnauthorizedError') {
    return res.status(401).json({
      error: 'UNAUTHORIZED',
      message: err.message || 'Authentication required'
    });
  }

  if (err.name === 'ForbiddenError') {
    return res.status(403).json({
      error: 'FORBIDDEN',
      message: err.message || 'Insufficient permissions'
    });
  }

  if (err.name === 'NotFoundError') {
    return res.status(404).json({
      error: 'NOT_FOUND',
      message: err.message || 'Resource not found'
    });
  }

  if (err.name === 'ConflictError') {
    return res.status(409).json({
      error: 'CONFLICT',
      message: err.message || 'Conflict occurred'
    });
  }

  // Handle HTTP errors
  if (createError.isHttpError(err)) {
    return res.status(err.statusCode).json({
      error: err.name,
      message: err.message || 'An error occurred'
    });
  }

  // Handle Sequelize database errors
  if (err.name === 'SequelizeValidationError') {
    return res.status(400).json({
      error: 'VALIDATION_ERROR',
      message: 'Validation failed',
      details: err.errors.map(e => ({
        field: e.path,
        message: e.message
      }))
    });
  }

  if (err.name === 'SequelizeUniqueConstraintError') {
    return res.status(409).json({
      error: 'CONFLICT',
      message: 'Resource already exists',
      details: err.errors.map(e => ({
        field: e.path,
        message: `${e.path} must be unique`
      }))
    });
  }

  if (err.name === 'SequelizeDatabaseError') {
    return res.status(500).json({
      error: 'DATABASE_ERROR',
      message: 'Database error occurred',
      details: err.message
    });
  }

  // Default to 500 server error
  res.status(500).json({
    error: 'INTERNAL_SERVER_ERROR',
    message: err.message || 'Internal server error'
  });
};

// Custom error classes
class ValidationError extends Error {
  constructor(message, details = []) {
    super(message);
    this.name = 'ValidationError';
    this.details = details;
  }
}

class UnauthorizedError extends Error {
  constructor(message = 'Authentication required') {
    super(message);
    this.name = 'UnauthorizedError';
  }
}

class ForbiddenError extends Error {
  constructor(message = 'Insufficient permissions') {
    super(message);
    this.name = 'ForbiddenError';
  }
}

class NotFoundError extends Error {
  constructor(message = 'Resource not found') {
    super(message);
    this.name = 'NotFoundError';
  }
}

class ConflictError extends Error {
  constructor(message = 'Conflict occurred') {
    super(message);
    this.name = 'ConflictError';
  }
}

module.exports = {
  errorHandler,
  ValidationError,
  UnauthorizedError,
  ForbiddenError,
  NotFoundError,
  ConflictError
};