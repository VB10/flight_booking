import 'package:flight_booking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

final class AppColorScheme {
  AppColorScheme._();

  static ColorScheme get light {
    final palette = AppColors.light;
    return ColorScheme(
      brightness: Brightness.light,
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      primaryContainer: palette.primaryContainer,
      onPrimaryContainer: palette.onPrimaryContainer,
      secondary: palette.secondary,
      onSecondary: palette.onSecondary,
      secondaryContainer: palette.secondaryContainer,
      onSecondaryContainer: palette.onSecondaryContainer,
      tertiary: palette.tertiary,
      onTertiary: palette.onTertiary,
      tertiaryContainer: palette.tertiaryContainer,
      onTertiaryContainer: palette.onTertiaryContainer,
      error: palette.error,
      onError: palette.onError,
      errorContainer: palette.errorContainer,
      onErrorContainer: palette.onErrorContainer,
      surface: palette.surface,
      onSurface: palette.onSurface,
      surfaceContainerHighest: palette.surfaceContainerHighest,
      onSurfaceVariant: palette.onSurfaceVariant,
      outline: palette.outline,
      outlineVariant: palette.outlineVariant,
    );
  }

  static ColorScheme get dark {
    final palette = AppColors.dark;
    return ColorScheme(
      brightness: Brightness.dark,
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      primaryContainer: palette.primaryContainer,
      onPrimaryContainer: palette.onPrimaryContainer,
      secondary: palette.secondary,
      onSecondary: palette.onSecondary,
      secondaryContainer: palette.secondaryContainer,
      onSecondaryContainer: palette.onSecondaryContainer,
      tertiary: palette.tertiary,
      onTertiary: palette.onTertiary,
      tertiaryContainer: palette.tertiaryContainer,
      onTertiaryContainer: palette.onTertiaryContainer,
      error: palette.error,
      onError: palette.onError,
      errorContainer: palette.errorContainer,
      onErrorContainer: palette.onErrorContainer,
      surface: palette.surface,
      onSurface: palette.onSurface,
      surfaceContainerHighest: palette.surfaceContainerHighest,
      onSurfaceVariant: palette.onSurfaceVariant,
      outline: palette.outline,
      outlineVariant: palette.outlineVariant,
    );
  }
}
