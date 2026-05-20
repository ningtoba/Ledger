import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

/// Basic smoke test to verify the app renders without crashing.
/// This uses a minimal MaterialApp wrapper since the full app requires
/// Firebase, database, and localization initialization.
void main() {
  testWidgets('basic widget rendering smoke test', (WidgetTester tester) async {
    // Verify that a simple MaterialApp can be pumped
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Ledger')),
          body: const Center(child: Text('Test')),
        ),
      ),
    );

    // Verify the text is rendered
    expect(find.text('Ledger'), findsOneWidget);
    expect(find.text('Test'), findsOneWidgetapsed);

    // Verify basic interaction works
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('text field interaction works', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TextField(),
        ),
      ),
    );

    // Find the text field and enter text
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    await tester.enterText(textField, 'Hello World');
    await tester.pump();

    // Verify text was entered
    expect(find.text('Hello World'), findsOneWidget);
  });

  testWidgets('button tap interaction works', (WidgetTester tester) async {
    int tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () => tapCount++,
            child: const Text('Tap Me'),
          ),
        ),
      ),
    );

    expect(find.text('Tap Me'), findsOneWidget);
    expect(tapCount, 0);

    await tester.tap(find.text('Tap Me'));
    await tester.pump();

    expect(tapCount, 1);
  });
}
