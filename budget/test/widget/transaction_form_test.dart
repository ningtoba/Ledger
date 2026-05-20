import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

/// Widget tests for transaction form components.
/// The full transaction form requires database/state initialization,
/// so these tests focus on individual form widgets in isolation.
void main() {
  group('TextFormField for amount input', () {
    testWidgets('renders with label and accepts input', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
        ),
      );

      // Verify the label is rendered
      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('\$'), findsOneWidget);

      // Enter a value
      await tester.enterText(find.byType(TextFormField), '42.50');
      await tester.pump();

      expect(controller.text, '42.50');
      controller.dispose();
    });

    testWidgets('validates empty input', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Amount is required';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      // Trigger validation
      formKey.currentState?.validate();
      await tester.pumpAndSettle();

      expect(find.text('Amount is required'), findsOneWidget);
    });
  });

  group('Dropdown for category selection', () {
    testWidgets('renders dropdown with items', (WidgetTester tester) async {
      String? selectedCategory;
      const categories = ['Food', 'Transport', 'Entertainment'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) => selectedCategory = value,
            ),
          ),
        ),
      );

      // Verify dropdown exists with hint
      expect(find.text('Category'), findsOneWidget);

      // Tap to open dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // Verify all items appear in the menu
      expect(find.text('Food'), findsWidgets);
      expect(find.text('Transport'), findsWidgets);
      expect(find.text('Entertainment'), findsWidgets);
    });
  });

  group('Date picker field', () {
    testWidgets('renders date text field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              controller: TextEditingController(text: '2024-03-15'),
            ),
          ),
        ),
      );

      expect(find.text('Date'), findsOneWidget);
      expect(find.text('2024-03-15'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });
  });
}
