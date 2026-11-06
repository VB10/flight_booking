import 'package:flight_booking/product/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// App theme = kit theme + the app's generated font family.
final class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme =>
      UiKitTheme.light(fontFamily: FontFamily.roboto);

  static ThemeData get darkTheme =>
      UiKitTheme.dark(fontFamily: FontFamily.roboto);
}
