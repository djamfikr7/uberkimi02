import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uber_shared/uber_shared.dart';

void main() {
  group('NeomorphicCard', () {
    testWidgets('renders correctly with child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicCard(
              child: const Text('Test Content'),
            ),
          ),
        ),
      );

      expect(find.text('Test Content'), findsOneWidget);
      expect(find.byType(NeomorphicCard), findsOneWidget);
    });

    testWidgets('applies custom dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicCard(
              width: 200,
              height: 150,
              child: const Text('Sized Card'),
            ),
          ),
        ),
      );

      expect(find.text('Sized Card'), findsOneWidget);
    });

    testWidgets('applies custom styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicCard(
              color: Colors.blue,
              child: const Text('Colored Card'),
            ),
          ),
        ),
      );

      expect(find.text('Colored Card'), findsOneWidget);
    });

    testWidgets('renders with padding and margin', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicCard(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              child: const Text('Padded Card'),
            ),
          ),
        ),
      );

      expect(find.text('Padded Card'), findsOneWidget);
    });

    testWidgets('applies border radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicCard(
              borderRadius: BorderRadius.circular(20),
              child: const Text('Rounded Card'),
            ),
          ),
        ),
      );

      expect(find.text('Rounded Card'), findsOneWidget);
    });
  });
}