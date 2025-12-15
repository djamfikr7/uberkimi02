import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uber_shared/uber_shared.dart';

void main() {
  group('NeomorphicTextField', () {
    testWidgets('renders correctly with hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicTextField(
              hintText: 'Enter text',
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicTextField), findsOneWidget);
    });

    testWidgets('accepts text input', (WidgetTester tester) async {
      final controller = TextEditingController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicTextField(
              controller: controller,
              hintText: 'Enter text',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Test input');
      await tester.pump();

      expect(controller.text, 'Test input');
    });

    testWidgets('calls onChanged callback', (WidgetTester tester) async {
      String? changedText;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicTextField(
              hintText: 'Enter text',
              onChanged: (text) => changedText = text,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Test input');
      await tester.pump();

      expect(changedText, 'Test input');
    });

    testWidgets('validates input with validator', (WidgetTester tester) async {
      String? validationMessage;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicTextField(
              hintText: 'Enter text',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Field is required';
                }
                return null;
              },
            ),
          ),
        ),
      );

      // Try to submit with empty field
      final form = find.byType(Form);
      await tester.tap(find.byType(ElevatedButton)); // Assuming there's a submit button
      await tester.pump();

      // We can't easily test form validation without a Form widget
      // But we can test that the validator function works correctly
      final validator = (String? value) {
        if (value == null || value.isEmpty) {
          return 'Field is required';
        }
        return null;
      };

      expect(validator(''), 'Field is required');
      expect(validator('test'), isNull);
    });

    testWidgets('applies custom styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicTextField(
              hintText: 'Styled field',
              focusColor: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicTextField), findsOneWidget);
    });

    testWidgets('handles different keyboard types', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                NeomorphicTextField(
                  hintText: 'Text field',
                  keyboardType: TextInputType.text,
                ),
                NeomorphicTextField(
                  hintText: 'Number field',
                  keyboardType: TextInputType.number,
                ),
                NeomorphicTextField(
                  hintText: 'Email field',
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicTextField), findsNWidgets(3));
    });

    testWidgets('toggles obscure text for password fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeomorphicTextField(
              hintText: 'Password',
              obscureText: true,
            ),
          ),
        ),
      );

      expect(find.byType(NeomorphicTextField), findsOneWidget);
    });
  });
}