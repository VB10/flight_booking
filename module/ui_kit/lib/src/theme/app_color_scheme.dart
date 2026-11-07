import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_colors.dart';

final class AppColorScheme {
  AppColorScheme._();

  static ColorScheme get light => _from(AppColors.light, Brightness.light);

  static ColorScheme get dark => _from(AppColors.dark, Brightness.dark);

  static ColorScheme _from(AppPalette p, Brightness brightness) => ColorScheme(
    brightness: brightness,
    primary: p.primary,
    onPrimary: p.onPrimary,
    primaryContainer: p.primaryContainer,
    onPrimaryContainer: p.onPrimaryContainer,
    secondary: p.secondary,
    onSecondary: p.onSecondary,
    secondaryContainer: p.secondaryContainer,
    onSecondaryContainer: p.onSecondaryContainer,
    tertiary: p.tertiary,
    onTertiary: p.onTertiary,
    tertiaryContainer: p.tertiaryContainer,
    onTertiaryContainer: p.onTertiaryContainer,
    error: p.error,
    onError: p.onError,
    errorContainer: p.errorContainer,
    onErrorContainer: p.onErrorContainer,
    surface: p.surface,
    onSurface: p.onSurface,
    surfaceContainerHighest: p.surfaceContainerHighest,
    onSurfaceVariant: p.onSurfaceVariant,
    outline: p.outline,
    outlineVariant: p.outlineVariant,
    scrim: p.scrim,
  );
}
