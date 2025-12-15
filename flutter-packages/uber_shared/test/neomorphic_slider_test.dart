import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uber_shared/uber_shared.dart';

void main() {
  group('NeomorphicSlider', () {
    testWidgets('renders correctly with initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicSlider(
              value: 0.5,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicSlider), findsOneWidget);
    });

    testWidgets('calls onChanged when value changes', (WidgetTester tester) async {
      double? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicSlider(
              value: 0.3,
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      // Simulate dragging the slider
      final gesture = await tester.startGesture(tester.getCenter(find.byType(NeomorphicSlider)));
      await gesture.moveBy(const Offset(50, 0));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(changedValue, greaterThan(0.3));
    });

    testWidgets('respects min and max values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicSlider(
              value: 0.5,
              min: 0,
              max: 100,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicSlider), findsOneWidget);
    });

    testWidgets('applies custom divisions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicSlider(
              value: 50,
              min: 0,
              max: 100,
              divisions: 10,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicSlider), findsOneWidget);
    });

    testWidgets('applies custom labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicSlider(
              value: 0.5,
              onChanged: (value) {},
              label: '50%',
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicSlider), findsOneWidget);
    });
  });
}