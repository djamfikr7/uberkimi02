// This is a basic Flutter widget test for the Admin App.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:admin_app/main.dart';

void main() {
  testWidgets('Admin App loads without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AdminApp());

    // Verify that the app loads without throwing exceptions
    expect(tester.takeException(), null);
  });
}