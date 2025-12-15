import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uber_shared/uber_shared.dart';

void main() {
  group('NeomorphicFab', () {
    testWidgets('renders correctly with child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: NeomorphicFab(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byType(NeomorphicFab), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: NeomorphicFab(
              onPressed: () => pressed = true,
              child: const Icon(Icons.add),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      await tester.tap(find.byType(NeomorphicFab));
      expect(pressed, isTrue);
    });

    testWidgets('does not respond to taps when disabled', (WidgetTester tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: NeomorphicFab(
              onPressed: () => pressed = true,
              isEnabled: false,
              child: const Icon(Icons.add),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      await tester.tap(find.byType(NeomorphicFab));
      expect(pressed, isFalse);
    });

    testWidgets('applies custom styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: NeomorphicFab(
              onPressed: () {},
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byType(NeomorphicFab), findsOneWidget);
    });

    testWidgets('applies custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: NeomorphicFab(
              onPressed: () {},
              size: 80,
              child: const Icon(Icons.add),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byType(NeomorphicFab), findsOneWidget);
    });
  });
}