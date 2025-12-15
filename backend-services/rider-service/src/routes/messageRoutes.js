const express = require('express');
const router = express.Router();
const { body, param } = require('express-validator');
const messageController = require('../controllers/messageController');
const authenticate = require('@shared-utils/authMiddleware');

// Send a new message
router.post('/send', 
  authenticate,
  [
    body('rideId').isUUID().withMessage('Valid ride ID is required'),
    body('recipientId').isUUID().withMessage('Valid recipient ID is required'),
    body('content').notEmpty().withMessage('Message content is required'),
    body('messageType').optional().isIn(['text', 'image', 'location']).withMessage('Invalid message type')
  ],
  messageController.sendMessage
);

// Get messages for a specific ride
router.get('/:rideId', 
  authenticate,
  [
    param('rideId').isUUID().withMessage('Valid ride ID is required')
  ],
  messageController.getRideMessages
);

// Mark messages as read
router.put('/mark-as-read',
  authenticate,
  [
    body('messageIds').isArray().withMessage('Message IDs must be an array')
  ],
  messageController.markMessagesAsRead
);

module.exports = router;