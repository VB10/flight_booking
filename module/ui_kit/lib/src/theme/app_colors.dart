import 'package:flutter/material.dart';

/// Raw color values of the design system — `docs/design/claude_design`
/// `Main.dc.html` › "1 · Color roles".
///
/// Widgets never read this class. They read the roles through
/// `Theme.of(context).colorScheme` and `context.appTheme`; this palette only
/// feeds `AppColorScheme` and `AppThemeExtension`.
@immutable
final class AppPalette {
  const AppPalette({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.surface,
    required this.onSurface,
    required this.surfaceContainerHighest,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.brandPrimary,
    required this.brandSecondary,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.cardBackground,
    required this.divider,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.scrim,
  });

  // Material 3 semantic roles
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color surface;
  final Color onSurface;
  final Color surfaceContainerHighest;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;

  // Extra semantic roles (AppThemeExtension)
  final Color brandPrimary;
  final Color brandSecondary;
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color infoContainer;
  final Color onInfoContainer;
  final Color cardBackground;
  final Color divider;
  final Color shimmerBase;
  final Color shimmerHighlight;

  /// Behind dialogs and the blocking overlay — black 50% light / 60% dark.
  final Color scrim;
}

final class AppColors {
  AppColors._();

  static const AppPalette light = AppPalette(
    primary: Color(0xFF1565C0),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD6E4FF),
    onPrimaryContainer: Color(0xFF001B3E),
    secondary: Color(0xFF0277BD),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFCCE8FF),
    onSecondaryContainer: Color(0xFF001E31),
    tertiary: Color(0xFF2E7D32),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFC8F0CB),
    onTertiaryContainer: Color(0xFF002106),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFF8FAFF),
    onSurface: Color(0xFF191C20),
    surfaceContainerHighest: Color(0xFFE1E2E9),
    onSurfaceVariant: Color(0xFF43474E),
    outline: Color(0xFF73777F),
    outlineVariant: Color(0xFFC3C6CF),
    brandPrimary: Color(0xFF0D47A1),
    brandSecondary: Color(0xFF0288D1),
    success: Color(0xFF1B7A36),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFC8F0CB),
    onSuccessContainer: Color(0xFF002106),
    warning: Color(0xFFB34F00),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFFE0C2),
    onWarningContainer: Color(0xFF3A1800),
    info: Color(0xFF006A8E),
    infoContainer: Color(0xFFC6E7FF),
    onInfoContainer: Color(0xFF001E2E),
    cardBackground: Color(0xFFFFFFFF),
    divider: Color(0xFFDDE0E8),
    shimmerBase: Color(0xFFE3E6EC),
    shimmerHighlight: Color(0xFFF4F6FA),
    scrim: Color(0x80000000),
  );

  static const AppPalette dark = AppPalette(
    primary: Color(0xFFA9C7FF),
    onPrimary: Color(0xFF002F65),
    primaryContainer: Color(0xFF00468C),
    onPrimaryContainer: Color(0xFFD6E4FF),
    secondary: Color(0xFF8FCDFF),
    onSecondary: Color(0xFF00344F),
    secondaryContainer: Color(0xFF004B71),
    onSecondaryContainer: Color(0xFFCCE8FF),
    tertiary: Color(0xFF8DD88F),
    onTertiary: Color(0xFF00390A),
    tertiaryContainer: Color(0xFF1B5120),
    onTertiaryContainer: Color(0xFFA9F5AA),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF101418),
    onSurface: Color(0xFFE1E2E8),
    surfaceContainerHighest: Color(0xFF32353A),
    onSurfaceVariant: Color(0xFFC3C6CF),
    outline: Color(0xFF8D9199),
    outlineVariant: Color(0xFF43474E),
    brandPrimary: Color(0xFF7FB2FF),
    brandSecondary: Color(0xFF4FC3F7),
    success: Color(0xFF7FD890),
    onSuccess: Color(0xFF00390F),
    successContainer: Color(0xFF1B5120),
    onSuccessContainer: Color(0xFFA9F5AA),
    warning: Color(0xFFFFB77A),
    onWarning: Color(0xFF4A2400),
    warningContainer: Color(0xFF6A3600),
    onWarningContainer: Color(0xFFFFDCC0),
    info: Color(0xFF7FD0F5),
    infoContainer: Color(0xFF004C6B),
    onInfoContainer: Color(0xFFC6E7FF),
    cardBackground: Color(0xFF1B1F25),
    divider: Color(0xFF2F343B),
    shimmerBase: Color(0xFF262B32),
    shimmerHighlight: Color(0xFF343A43),
    scrim: Color(0x99000000),
  );
}
