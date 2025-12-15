import 'package:flutter/material.dart';
import 'package:uber_shared/theme/app_theme.dart';
import 'package:uber_shared/models/message.dart';
import 'package:uber_shared/widgets/neomorphic_card.dart';
import 'package:uber_shared/widgets/neomorphic_text_field.dart';
import 'package:uber_shared/widgets/neomorphic_button.dart';

/// A chat widget for messaging between rider and driver during a ride
class ChatWidget extends StatefulWidget {
  final List<Message> messages;
  final Function(String) onSendMessage;
  final bool isLoading;
  final String currentUserID;

  const ChatWidget({
    Key? key,
    required this.messages,
    required this.onSendMessage,
    this.isLoading = false,
    required this.currentUserID,
  }) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Scroll to bottom when new messages arrive
    if (widget.messages.length > oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSend() {
    if (_messageController.text.trim().isNotEmpty) {
      widget.onSendMessage(_messageController.text.trim());
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NeomorphicCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Chat header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble, color: AppTheme.primaryLight),
                const SizedBox(width: 8),
                Text(
                  'Chat with your contact',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 18,
                    color: AppTheme.primaryLight,
                  ),
                ),
              ],
            ),
          ),
          
          // Messages list
          Expanded(
            child: widget.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.messages.length,
                    itemBuilder: (context, index) {
                      final message = widget.messages[index];
                      final isSentByCurrentUser = message.senderId == widget.currentUserID;
                      
                      return _buildMessageBubble(message, isSentByCurrentUser);
                    },
                  ),
          ),
          
          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isSentByCurrentUser) {
    return Align(
      alignment: isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: NeomorphicCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: isSentByCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (message.messageType == 'text')
                Text(
                  message.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSentByCurrentUser ? AppTheme.primaryLight : AppTheme.textPrimary,
                  ),
                ),
              if (message.messageType == 'location')
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppTheme.primaryLight),
                    const SizedBox(width: 4),
                    Text(
                      'Shared location',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 4),
              Text(
                _formatTime(message.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(top: BorderSide(color: AppTheme.neutral)),
      ),
      child: Row(
        children: [
          Expanded(
            child: NeomorphicTextField(
              controller: _messageController,
              hintText: 'Type a message...',
              maxLines: null,
              keyboardType: TextInputType.multiline,
              // Removed unsupported properties
            ),
          ),
          const SizedBox(width: 8),
          NeomorphicButton(
            onPressed: _handleSend,
            padding: const EdgeInsets.all(12),
            child: const Icon(Icons.send, size: 20),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}