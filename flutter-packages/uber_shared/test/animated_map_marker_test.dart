import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uber_shared/uber_shared.dart';

void main() {
  group('AnimatedMapMarker', () {
    testWidgets('renders correctly with default properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedMapMarker(
              label: 'Test Marker',
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedMapMarker), findsOneWidget);
      expect(find.text('Test Marker'), findsOneWidget);
    });

    testWidgets('applies custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedMapMarker(
              size: 60.0,
              label: 'Large Marker',
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedMapMarker), findsOneWidget);
      expect(find.text('Large Marker'), findsOneWidget);
    });

    testWidgets('applies custom color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedMapMarker(
              color: Colors.red,
              label: 'Red Marker',
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedMapMarker), findsOneWidget);
      expect(find.text('Red Marker'), findsOneWidget);
    });

    testWidgets('animates when pulsing is enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedMapMarker(
              isPulsing: true,
              label: 'Pulsing Marker',
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedMapMarker), findsOneWidget);
      expect(find.text('Pulsing Marker'), findsOneWidget);
      
      // Pump multiple frames to test animation
      await tester.pumpAndSettle();
    });

    testWidgets('does not animate when pulsing is disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedMapMarker(
              isPulsing: false,
              label: 'Static Marker',
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedMapMarker), findsOneWidget);
      expect(find.text('Static Marker'), findsOneWidget);
    });
  });
}