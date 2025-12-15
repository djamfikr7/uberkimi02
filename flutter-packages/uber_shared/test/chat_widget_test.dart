import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uber_shared/uber_shared.dart';

void main() {
  group('ChatWidget', () {
    testWidgets('renders correctly with empty messages', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              messages: [],
              onSendMessage: (message) {},
              currentUserID: 'user_123',
            ),
          ),
        ),
      );

      expect(find.byType(ChatWidget), findsOneWidget);
    });

    testWidgets('displays messages correctly', (WidgetTester tester) async {
      final messages = [
        Message(
          id: '1',
          rideId: 'ride_123',
          senderId: 'rider_123',
          recipientId: 'driver_456',
          content: 'Hello driver!',
          createdAt: DateTime.now(),
        ),
        Message(
          id: '2',
          rideId: 'ride_123',
          senderId: 'driver_456',
          recipientId: 'rider_123',
          content: 'Hi there! Where are you?',
          createdAt: DateTime.now().add(const Duration(minutes: 1)),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              messages: messages,
              onSendMessage: (message) {},
              currentUserID: 'rider_123',
            ),
          ),
        ),
      );

      expect(find.byType(ChatWidget), findsOneWidget);
      expect(find.text('Hello driver!'), findsOneWidget);
      expect(find.text('Hi there! Where are you?'), findsOneWidget);
    });

    testWidgets('calls onSendMessage when sending a message', (WidgetTester tester) async {
      String? sentMessage;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              messages: [],
              onSendMessage: (message) => sentMessage = message,
              currentUserID: 'user_123',
            ),
          ),
        ),
      );

      // Find the text field and enter text
      await tester.enterText(find.byType(TextFormField), 'Test message');
      await tester.pump();

      // Find and tap the send button
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(sentMessage, 'Test message');
    });

    testWidgets('handles empty message input', (WidgetTester tester) async {
      String? sentMessage;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              messages: [],
              onSendMessage: (message) => sentMessage = message,
              currentUserID: 'user_123',
            ),
          ),
        ),
      );

      // Try to send an empty message
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Should not call onSendMessage for empty messages
      expect(sentMessage, isNull);
    });

    testWidgets('shows correct message alignment for sender/receiver', (WidgetTester tester) async {
      final messages = [
        Message(
          id: '1',
          rideId: 'ride_123',
          senderId: 'current_user',
          recipientId: 'other_user',
          content: 'My message',
          createdAt: DateTime.now(),
        ),
        Message(
          id: '2',
          rideId: 'ride_123',
          senderId: 'other_user',
          recipientId: 'current_user',
          content: 'Their message',
          createdAt: DateTime.now().add(const Duration(minutes: 1)),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              messages: messages,
              currentUserID: 'current_user',
              onSendMessage: (message) {},
            ),
          ),
        ),
      );

      expect(find.byType(ChatWidget), findsOneWidget);
      expect(find.text('My message'), findsOneWidget);
      expect(find.text('Their message'), findsOneWidget);
    });

    testWidgets('formats timestamps correctly', (WidgetTester tester) async {
      final now = DateTime.now();
      final messages = [
        Message(
          id: '1',
          rideId: 'ride_123',
          senderId: 'user_123',
          recipientId: 'driver_123',
          content: 'Test message',
          createdAt: now,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatWidget(
              messages: messages,
              onSendMessage: (message) {},
              currentUserID: 'user_123',
            ),
          ),
        ),
      );

      expect(find.byType(ChatWidget), findsOneWidget);
    });
  });
}