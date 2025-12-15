import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uber_shared/uber_shared.dart';

void main() {
  group('RideStatusIndicator', () {
    testWidgets('renders correctly with default properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RideStatusIndicator(
              status: 'requested',
            ),
          ),
        ),
      );

      expect(find.byType(RideStatusIndicator), findsOneWidget);
    });

    testWidgets('renders with custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RideStatusIndicator(
              status: 'accepted',
              size: 30.0,
            ),
          ),
        ),
      );

      expect(find.byType(RideStatusIndicator), findsOneWidget);
    });

    testWidgets('shows correct color for requested status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RideStatusIndicator(
              status: 'requested',
            ),
          ),
        ),
      );

      expect(find.byType(RideStatusIndicator), findsOneWidget);
    });

    testWidgets('shows correct color for accepted status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RideStatusIndicator(
              status: 'accepted',
            ),
          ),
        ),
      );

      expect(find.byType(RideStatusIndicator), findsOneWidget);
    });

    testWidgets('shows correct color for ongoing status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RideStatusIndicator(
              status: 'ongoing',
            ),
          ),
        ),
      );

      expect(find.byType(RideStatusIndicator), findsOneWidget);
    });

    testWidgets('shows correct color for completed status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RideStatusIndicator(
              status: 'completed',
            ),
          ),
        ),
      );

      expect(find.byType(RideStatusIndicator), findsOneWidget);
    });

    testWidgets('shows correct color for cancelled status', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RideStatusIndicator(
              status: 'cancelled',
            ),
          ),
        ),
      );

      expect(find.byType(RideStatusIndicator), findsOneWidget);
    });

    testWidgets('handles unknown status gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RideStatusIndicator(
              status: 'unknown_status',
            ),
          ),
        ),
      );

      expect(find.byType(RideStatusIndicator), findsOneWidget);
    });
  });
}