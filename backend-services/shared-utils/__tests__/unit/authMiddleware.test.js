const { authenticate } = require('../../lib/authMiddleware');

describe('Authentication Middleware', () => {
  test('should authenticate valid token', () => {
    // Mock request with valid token
    const req = {
      headers: {
        authorization: 'Bearer valid_token'
      }
    };
    
    // Mock response and next function
    const res = {};
    const next = jest.fn();
    
    // Mock jwt.verify to return a valid user
    jest.mock('jsonwebtoken', () => ({
      verify: jest.fn().mockReturnValue({ id: 'user123', email: 'test@example.com' })
    }));
    
    authenticate(req, res, next);
    
    expect(next).toHaveBeenCalled();
    expect(req.user).toBeDefined();
    expect(req.user.id).toBe('user123');
  });

  test('should reject missing token', () => {
    const req = { headers: {} };
    const res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn()
    };
    const next = jest.fn();
    
    authenticate(req, res, next);
    
    expect(res.status).toHaveBeenCalledWith(401);
    expect(res.json).toHaveBeenCalledWith({ message: 'Access token is required' });
    expect(next).not.toHaveBeenCalled();
  });

  test('should reject invalid token', () => {
    const req = {
      headers: {
        authorization: 'Bearer invalid_token'
      }
    };
    const res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn()
    };
    const next = jest.fn();
    
    // Mock jwt.verify to throw an error
    jest.mock('jsonwebtoken', () => ({
      verify: jest.fn().mockImplementation(() => {
        throw new Error('Invalid token');
      })
    }));
    
    authenticate(req, res, next);
    
    expect(res.status).toHaveBeenCalledWith(401);
    expect(res.json).toHaveBeenCalledWith({ message: 'Invalid or expired token' });
    expect(next).not.toHaveBeenCalled();
  });
});