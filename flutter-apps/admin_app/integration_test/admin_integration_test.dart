import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Admin App Integration Tests', () {
    testWidgets('Admin App loads without errors', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify the app loads without throwing exceptions
      expect(tester.takeException(), null);
    });
  });
}