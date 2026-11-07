import 'package:flutter/material.dart';

/// Material 3 type scale — `Main.dc.html` › "3 · Typography".
///
/// No font family here: the app passes it to `UiKitTheme` (it owns the font
/// assets), and `ThemeData(fontFamily:)` applies it to this whole scale.
final class AppTextStyles {
  AppTextStyles._();

  static TextStyle _s(
    double size,
    double height,
    FontWeight weight, [
    double letterSpacing = 0,
  ]) => TextStyle(
    fontSize: size,
    height: height / size,
    fontWeight: weight,
    letterSpacing: letterSpacing,
  );

  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;

  static TextStyle get displayLarge => _s(57, 64, _regular, -0.25);
  static TextStyle get displayMedium => _s(45, 52, _regular);
  static TextStyle get displaySmall => _s(36, 44, _regular);
  static TextStyle get headlineLarge => _s(32, 40, _regular);
  static TextStyle get headlineMedium => _s(28, 36, _regular);
  static TextStyle get headlineSmall => _s(24, 32, _regular);
  static TextStyle get titleLarge => _s(22, 28, _regular);
  static TextStyle get titleMedium => _s(16, 24, _medium, 0.15);
  static TextStyle get titleSmall => _s(14, 20, _medium, 0.1);
  static TextStyle get bodyLarge => _s(16, 24, _regular, 0.5);
  static TextStyle get bodyMedium => _s(14, 20, _regular, 0.25);
  static TextStyle get bodySmall => _s(12, 16, _regular, 0.4);
  static TextStyle get labelLarge => _s(14, 20, _medium, 0.1);
  static TextStyle get labelMedium => _s(12, 16, _medium, 0.5);
  static TextStyle get labelSmall => _s(11, 16, _medium, 0.5);

  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
