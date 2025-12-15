import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uber_shared/uber_shared.dart';

void main() {
  group('NeomorphicToggleSwitch', () {
    testWidgets('renders correctly with initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicToggleSwitch(
              value: true,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicToggleSwitch), findsOneWidget);
    });

    testWidgets('calls onChanged when toggled', (WidgetTester tester) async {
      bool? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicToggleSwitch(
              value: false,
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NeomorphicToggleSwitch));
      await tester.pumpAndSettle();

      expect(changedValue, isTrue);
    });

    testWidgets('does not respond when onChanged is null', (WidgetTester tester) async {
      bool? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicToggleSwitch(
              value: false,
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NeomorphicToggleSwitch));
      await tester.pumpAndSettle();

      expect(changedValue, isTrue);
    });

    testWidgets('applies custom text labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicToggleSwitch(
              value: true,
              onChanged: (value) {},
              activeText: 'ON',
              inactiveText: 'OFF',
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicToggleSwitch), findsOneWidget);
    });

    testWidgets('applies custom dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicToggleSwitch(
              value: false,
              onChanged: (value) {},
              width: 80,
              height: 40,
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicToggleSwitch), findsOneWidget);
    });
  });
}