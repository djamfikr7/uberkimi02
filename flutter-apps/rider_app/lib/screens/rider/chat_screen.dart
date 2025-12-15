import 'package:flutter/material.dart';
import 'package:uber_shared/uber_shared.dart' hide AppTheme;
import 'package:rider_app/theme/app_theme.dart' as rider_theme;
import 'package:rider_app/services/api_service.dart';
import 'package:rider_app/config/environment.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final String rideId;
  final String driverId;
  final String currentUserId;

  const ChatScreen({
    Key? key,
    required this.rideId,
    required this.driverId,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late io.Socket socket;
  List<Message> messages = [];
  bool isLoading = false;
  StreamSubscription? _socketSubscription;

  @override
  void initState() {
    super.initState();
    _connectToSocket();
    _loadMessages();
  }

  void _connectToSocket() {
    // Initialize socket connection
    socket = io.io(Environment.socketBaseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.connect();

    // Listen for incoming messages
    socket.on('receive_message', (data) {
      setState(() {
        final message = Message.fromJson({
          'id': data['messageId'] ?? '',
          'ride_id': widget.rideId,
          'sender_id': data['senderId'] ?? '',
          'recipient_id': widget.currentUserId,
          'content': data['content'] ?? '',
          'message_type': data['messageType'] ?? 'text',
          'is_read': false,
          'created_at': data['sentAt'] ?? DateTime.now().toIso8601String(),
        });
        messages.add(message);
      });
    });

    // Listen for message sent confirmation
    socket.on('message_sent', (data) {
      // Message was successfully sent, no additional action needed
    });

    // Listen for message errors
    socket.on('message_error', (data) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['error'] ?? 'Failed to send message'),
          backgroundColor: rider_theme.AppTheme.errorColor,
        ),
      );
    });
  }

  Future<void> _loadMessages() async {
    setState(() => isLoading = true);
    try {
      final url = Uri.parse('${Environment.apiBaseUrl}/messages/${widget.rideId}');
      final token = await ApiService().getToken();
      
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer \$token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            messages = (data['data'] as List)
                .map((msg) => Message.fromJson(msg))
                .toList();
          });
        }
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load messages'),
          backgroundColor: rider_theme.AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _sendMessage(String content) {
    // Send message through socket
    socket.emit('send_message', {
      'rideId': widget.rideId,
      'recipientId': widget.driverId,
      'content': content,
      'messageType': 'text',
    });
  }

  @override
  void dispose() {
    socket.dispose();
    _socketSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Driver'),
        backgroundColor: rider_theme.AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ChatWidget(
        messages: messages,
        onSendMessage: _sendMessage,
        isLoading: isLoading,
        currentUserID: widget.currentUserId,
      ),
    );
  }
}