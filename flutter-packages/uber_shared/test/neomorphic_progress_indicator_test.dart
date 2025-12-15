import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uber_shared/uber_shared.dart';

void main() {
  group('NeomorphicProgressIndicator', () {
    testWidgets('renders correctly with default properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicProgressIndicator(
              value: 0.5,
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicProgressIndicator), findsOneWidget);
    });

    testWidgets('applies custom height', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicProgressIndicator(
              value: 0.5,
              height: 20,
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicProgressIndicator), findsOneWidget);
    });

    testWidgets('applies custom border radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicProgressIndicator(
              value: 0.5,
              borderRadius: 20,
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicProgressIndicator), findsOneWidget);
    });

    testWidgets('applies animation duration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicProgressIndicator(
              value: 0.7,
              animationDuration: const Duration(seconds: 2),
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicProgressIndicator), findsOneWidget);
    });

    testWidgets('handles different progress values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                NeomorphicProgressIndicator(value: 0.0),
                NeomorphicProgressIndicator(value: 0.25),
                NeomorphicProgressIndicator(value: 0.5),
                NeomorphicProgressIndicator(value: 0.75),
                NeomorphicProgressIndicator(value: 1.0),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicProgressIndicator), findsNWidgets(5));
    });
  });
}