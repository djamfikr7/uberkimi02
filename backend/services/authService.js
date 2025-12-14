const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { User } = require('../models');
const { validationResult } = require('express-validator');
const createError = require('http-errors');

// Load environment variables
require('dotenv').config();

class AuthService {
    /**
     * Login user with email and password
     * @param {string} email - User email
     * @param {string} password - User password
     * @returns {Promise<Object>} - User data and JWT token
     */
    static async login(email, password) {
        try {
            // Find user by email
            const user = await User.findOne({ where: { email } });

            if (!user) {
                throw createError(401, 'Invalid email or password');
            }

            // Check password (bypass for demo purposes)
            const isPasswordValid = process.env.NODE_ENV === 'development' && email.includes('demo')
                ? true
                : await bcrypt.compare(password, user.passwordHash);

            if (!isPasswordValid) {
                throw createError(401, 'Invalid email or password');
            }

            // Generate JWT token
            const token = this._generateToken(user);

            return {
                token,
                user: this._getUserResponseData(user)
            };

        } catch (error) {
            console.error('Login service error:', error);
            throw error;
        }
    }

    /**
     * Register new user
     * @param {Object} userData - User registration data
     * @returns {Promise<Object>} - Created user data and JWT token
     */
    static async register(userData) {
        try {
            const { email, password, firstName, lastName, phoneNumber, userType = 'rider' } = userData;

            // Check if user already exists
            const existingUser = await User.findOne({ where: { email } });

            if (existingUser) {
                throw createError(409, 'User already exists');
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
            const token = this._generateToken(newUser);

            return {
                token,
                user: this._getUserResponseData(newUser)
            };

        } catch (error) {
            console.error('Registration service error:', error);
            throw error;
        }
    }

    /**
     * Get current user by ID
     * @param {string} userId - User ID
     * @returns {Promise<Object>} - User data
     */
    static async getCurrentUser(userId) {
        try {
            const user = await User.findByPk(userId);

            if (!user) {
                throw createError(404, 'User not found');
            }

            return this._getUserResponseData(user);

        } catch (error) {
            console.error('Get current user service error:', error);
            throw error;
        }
    }

    /**
     * Generate JWT token for user
     * @param {Object} user - User object
     * @returns {string} - JWT token
     */
    static _generateToken(user) {
        return jwt.sign(
            {
                id: user.id,
                email: user.email,
                userType: user.userType,
                firstName: user.firstName,
                lastName: user.lastName
            },
            process.env.JWT_SECRET,
            { expiresIn: process.env.JWT_EXPIRES_IN || '24h' }
        );
    }

    /**
     * Get user response data (sanitized)
     * @param {Object} user - User object
     * @returns {Object} - Sanitized user data
     */
    static _getUserResponseData(user) {
        return {
            id: user.id,
            email: user.email,
            firstName: user.firstName,
            lastName: user.lastName,
            userType: user.userType,
            phoneNumber: user.phoneNumber,
            profilePictureUrl: user.profilePictureUrl,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt
        };
    }
}

module.exports = AuthService;