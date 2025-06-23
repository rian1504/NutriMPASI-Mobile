import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrimpasi/main.dart';

void main() {
  testWidgets('App initializes correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MainApp());

    // Add assertions for initial app state
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
