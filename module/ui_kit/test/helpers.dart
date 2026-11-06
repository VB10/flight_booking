import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

Future<void> pumpKit(
  WidgetTester tester,
  Widget child, {
  bool dark = false,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: UiKitTheme.light(),
      darkTheme: UiKitTheme.dark(),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(body: Center(child: child)),
    ),
  );
}
