const { Message, Ride, User } = require('@shared-utils/dbModels');
const { validationResult } = require('express-validator');
const { Op } = require('sequelize');

/**
 * Send a new message
 */
async function sendMessage(req, res) {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }

    const { rideId, recipientId, content, messageType } = req.body;
    const senderId = req.user.id;

    // Verify that the sender is part of the ride
    const ride = await Ride.findOne({
      where: {
        id: rideId,
        [Op.or]: [
          { riderId: senderId },
          { driverId: senderId }
        ]
      }
    });

    if (!ride) {
      return res.status(403).json({
        success: false,
        message: 'You are not authorized to send messages for this ride'
      });
    }

    // Verify that the recipient is also part of the ride
    if (recipientId !== ride.riderId && recipientId !== ride.driverId) {
      return res.status(400).json({
        success: false,
        message: 'Recipient is not part of this ride'
      });
    }

    // Create the message
    const message = await Message.create({
      rideId,
      senderId,
      recipientId,
      content,
      messageType: messageType || 'text'
    });

    // Populate sender and recipient details
    const populatedMessage = await Message.findByPk(message.id, {
      include: [
        {
          model: User,
          as: 'sender',
          attributes: ['id', 'firstName', 'lastName', 'profilePictureUrl']
        },
        {
          model: User,
          as: 'recipient',
          attributes: ['id', 'firstName', 'lastName', 'profilePictureUrl']
        }
      ]
    });

    res.status(201).json({
      success: true,
      message: 'Message sent successfully',
      data: populatedMessage
    });
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).json({
      success: false,
      message: 'Error sending message',
      error: process.env.NODE_ENV === 'development' ? error.message : {}
    });
  }
}

/**
 * Get messages for a specific ride
 */
async function getRideMessages(req, res) {
  try {
    const { rideId } = req.params;
    const userId = req.user.id;

    // Verify that the user is part of the ride
    const ride = await Ride.findOne({
      where: {
        id: rideId,
        [Op.or]: [
          { riderId: userId },
          { driverId: userId }
        ]
      }
    });

    if (!ride) {
      return res.status(403).json({
        success: false,
        message: 'You are not authorized to view messages for this ride'
      });
    }

    // Get all messages for this ride with sender/recipient details
    const messages = await Message.findAll({
      where: {
        rideId: rideId
      },
      include: [
        {
          model: User,
          as: 'sender',
          attributes: ['id', 'firstName', 'lastName', 'profilePictureUrl']
        },
        {
          model: User,
          as: 'recipient',
          attributes: ['id', 'firstName', 'lastName', 'profilePictureUrl']
        }
      ],
      order: [['createdAt', 'ASC']]
    });

    res.status(200).json({
      success: true,
      message: 'Messages retrieved successfully',
      data: messages
    });
  } catch (error) {
    console.error('Error retrieving messages:', error);
    res.status(500).json({
      success: false,
      message: 'Error retrieving messages',
      error: process.env.NODE_ENV === 'development' ? error.message : {}
    });
  }
}

/**
 * Mark messages as read
 */
async function markMessagesAsRead(req, res) {
  try {
    const { messageIds } = req.body;
    const userId = req.user.id;

    // Update messages that belong to the user
    const [updatedRows] = await Message.update(
      { isRead: true },
      {
        where: {
          id: {
            [Op.in]: messageIds
          },
          recipientId: userId
        }
      }
    );

    res.status(200).json({
      success: true,
      message: `${updatedRows} messages marked as read`,
      data: { updatedRows }
    });
  } catch (error) {
    console.error('Error marking messages as read:', error);
    res.status(500).json({
      success: false,
      message: 'Error marking messages as read',
      error: process.env.NODE_ENV === 'development' ? error.message : {}
    });
  }
}

module.exports = {
  sendMessage,
  getRideMessages,
  markMessagesAsRead
};