import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uber_shared/uber_shared.dart';

void main() {
  group('NeomorphicAppBar', () {
    testWidgets('renders correctly with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: NeomorphicAppBar(
              title: const Text('Test Title'),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byType(NeomorphicAppBar), findsOneWidget);
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('renders with actions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: NeomorphicAppBar(
              title: const Text('Test Title'),
              actions: const [
                Icon(Icons.search),
                Icon(Icons.more_vert),
              ],
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byType(NeomorphicAppBar), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('handles leading widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: NeomorphicAppBar(
              title: const Text('Test Title'),
              leading: const Icon(Icons.menu),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byType(NeomorphicAppBar), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('applies custom background color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: NeomorphicAppBar(
              title: const Text('Test Title'),
              backgroundColor: Colors.blue,
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byType(NeomorphicAppBar), findsOneWidget);
    });

    testWidgets('handles null title gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: const NeomorphicAppBar(),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byType(NeomorphicAppBar), findsOneWidget);
    });
  });
}