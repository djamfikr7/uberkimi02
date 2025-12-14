const { validationResult } = require('express-validator');
const createError = require('http-errors');
const AuthService = require('../services/authService');

// Load environment variables
require('dotenv').config();

// Login controller (bypass OTP as requested)
const login = async (req, res, next) => {
  try {
    // Validate request
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'VALIDATION_ERROR',
        message: 'Validation failed',
        details: errors.array()
      });
    }

    const { email, password } = req.body;

    // Use AuthService for login
    const { token, user } = await AuthService.login(email, password);

    // Return response
    res.json({
      success: true,
      message: 'Login successful',
      data: {
        token,
        user
      }
    });

  } catch (error) {
    console.error('Login error:', error);
    next(error);
  }
};

// Register controller
const register = async (req, res, next) => {
  try {
    // Validate request
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'VALIDATION_ERROR',
        message: 'Validation failed',
        details: errors.array()
      });
    }

    const { email, password, firstName, lastName, phoneNumber, userType = 'rider' } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({ where: { email } });

    if (existingUser) {
      return res.status(409).json({
        error: 'CONFLICT',
        message: 'User already exists'
      });
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    // Create new user
    const newUser = await User.create({
      email,
      passwordHash,
      firstName,
      lastName,
      phoneNumber,
      userType,
      profilePictureUrl: `https://randomuser.me/api/portraits/${Math.random() > 0.5 ? 'men' : 'women'}/${Math.floor(Math.random() * 100)}.jpg`
    });

    // Generate JWT token
    const token = jwt.sign(
      {
        id: newUser.id,
        email: newUser.email,
        userType: newUser.userType,
        firstName: newUser.firstName,
        lastName: newUser.lastName
      },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '24h' }
    );

    // Return response
    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      data: {
        token,
        user: {
          id: newUser.id,
          email: newUser.email,
          firstName: newUser.firstName,
          lastName: newUser.lastName,
          userType: newUser.userType,
          phoneNumber: newUser.phoneNumber,
          profilePictureUrl: newUser.profilePictureUrl
        }
      }
    });

  } catch (error) {
    console.error('Registration error:', error);
    next(createError(500, 'Internal server error'));
  }
};

// Get current user
const getCurrentUser = async (req, res, next) => {
  try {
    const user = req.user;

    if (!user) {
      return res.status(401).json({
        error: 'UNAUTHORIZED',
        message: 'User not authenticated'
      });
    }

    // Find user in database
    const dbUser = await User.findByPk(user.id);

    if (!dbUser) {
      return res.status(404).json({
        error: 'NOT_FOUND',
        message: 'User not found'
      });
    }

    // Return user data
    res.json({
      success: true,
      message: 'User data retrieved successfully',
      data: {
        user: {
          id: dbUser.id,
          email: dbUser.email,
          firstName: dbUser.firstName,
          lastName: dbUser.lastName,
          userType: dbUser.userType,
          phoneNumber: dbUser.phoneNumber,
          profilePictureUrl: dbUser.profilePictureUrl,
          createdAt: dbUser.createdAt,
          updatedAt: dbUser.updatedAt
        }
      }
    });

  } catch (error) {
    console.error('Get current user error:', error);
    next(createError(500, 'Internal server error'));
  }
};

module.exports = {
  login,
  register,
  getCurrentUser
};