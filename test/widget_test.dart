import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simplecalc/main.dart';

void main() {
  testWidgets('Calculator simple addition test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Initially displays '0'
    expect(find.text('0'), findsWidgets);

    // Tap '7'
    await tester.tap(find.text('7'));
    await tester.pump();

    // Tap '+'
    await tester.tap(find.text('+'));
    await tester.pump();

    // Tap '5'
    await tester.tap(find.text('5'));
    await tester.pump();

    // Tap '='
    await tester.tap(find.text('='));
    await tester.pump();

    // Output should be '12'
    expect(find.text('12'), findsOneWidget);
  });

  testWidgets('2+2', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Initially displays '0'
    expect(find.text('0'), findsWidgets);

    // Tap '2'
    await tester.tap(find.widgetWithText(ElevatedButton, '2'));
    await tester.pump();

    // Tap '+'
    await tester.tap(find.text('+'));
    await tester.pump();

    // Tap '2'
    await tester.tap(find.widgetWithText(ElevatedButton, '2'));
    await tester.pump();

    // Tap '='
    await tester.tap(find.text('='));
    await tester.pump();

    // Output should be '4'
    expect(find.text('4'), findsWidgets);
  });

  testWidgets('Subtraction test (9 - 4 = 5)', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(ElevatedButton, '9'));
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, '-'));
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, '4'));
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, '='));
    await tester.pump();

    expect(find.text('5'), findsWidgets);
  });

  testWidgets('Multiplication test (6 × 3 = 18)', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(ElevatedButton, '6'));
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, '×'));
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, '3'));
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, '='));
    await tester.pump();

    expect(find.text('18'), findsOneWidget);
  });

  testWidgets('Division test (8 ÷ 2 = 4)', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(ElevatedButton, '8'));
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, '÷'));
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, '2'));
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, '='));
    await tester.pump();

    expect(find.text('4'), findsWidgets);
  });

  testWidgets('Clear button test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(ElevatedButton, '5'));
    await tester.pump();

    // Tap 'C'
    await tester.tap(find.widgetWithText(ElevatedButton, 'C'));
    await tester.pump();

    expect(find.text('0'), findsWidgets);
  });
}
