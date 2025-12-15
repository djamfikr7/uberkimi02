/// Message model representing a chat message between rider and driver
/// This model is shared across all three applications (Rider, Driver, Admin).
class Message {
  final String id;
  final String rideId;
  final String senderId;
  final String recipientId;
  final String content;
  final String messageType; // 'text', 'image', 'location'
  final bool isRead;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Message({
    required this.id,
    required this.rideId,
    required this.senderId,
    required this.recipientId,
    required this.content,
    this.messageType = 'text',
    this.isRead = false,
    required this.createdAt,
    this.updatedAt,
  });

  /// Creates a Message instance from a JSON object
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      rideId: json['ride_id'] as String,
      senderId: json['sender_id'] as String,
      recipientId: json['recipient_id'] as String,
      content: json['content'] as String,
      messageType: json['message_type'] as String? ?? 'text',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Converts a Message instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ride_id': rideId,
      'sender_id': senderId,
      'recipient_id': recipientId,
      'content': content,
      'message_type': messageType,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Message(id: $id, rideId: $rideId, senderId: $senderId, recipientId: $recipientId, content: $content, messageType: $messageType)';
  }
}