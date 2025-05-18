import 'package:flutter_test/flutter_test.dart';
import 'package:equation_support/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {

    await tester.pumpWidget(const CalculatorApp());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
