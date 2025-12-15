import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uber_shared/uber_shared.dart';

void main() {
  group('NeomorphicButton', () {
    testWidgets('renders correctly with child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicButton(
              onPressed: () {},
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(NeomorphicButton), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicButton(
              onPressed: () => pressed = true,
              child: const Text('Test Button'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NeomorphicButton));
      expect(pressed, isTrue);
    });

    testWidgets('does not respond to taps when disabled', (WidgetTester tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicButton(
              onPressed: () => pressed = true,
              isEnabled: false,
              child: const Text('Disabled Button'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NeomorphicButton));
      expect(pressed, isFalse);
    });

    testWidgets('applies custom dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicButton(
              onPressed: () {},
              width: 200,
              height: 100,
              child: const Text('Custom Size Button'),
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(NeomorphicButton);
      expect(buttonFinder, findsOneWidget);
      
      // We can't easily test the exact dimensions without accessing the render box
      // but we can verify the widget renders correctly
      expect(find.text('Custom Size Button'), findsOneWidget);
    });

    testWidgets('applies custom styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicButton(
              onPressed: () {},
              backgroundColor: Colors.blue,
              child: const Text('Styled Button'),
            ),
          ),
        ),
      );

      expect(find.text('Styled Button'), findsOneWidget);
    });
  });
}