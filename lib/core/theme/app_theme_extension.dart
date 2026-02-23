import 'package:flight_booking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

final class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.brandPrimary,
    required this.brandSecondary,
    required this.success,
    required this.warning,
    required this.info,
    required this.cardBackground,
    required this.divider,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  final Color brandPrimary;
  final Color brandSecondary;
  final Color success;
  final Color warning;
  final Color info;
  final Color cardBackground;
  final Color divider;
  final Color shimmerBase;
  final Color shimmerHighlight;

  static AppThemeExtension light = AppThemeExtension(
    brandPrimary: AppColors.light.primary,
    brandSecondary: AppColors.light.secondary,
    success: AppColors.light.tertiary,
    warning: const Color(0xFFFF9800),
    info: AppColors.light.secondary,
    cardBackground: AppColors.light.surface,
    divider: AppColors.light.outlineVariant,
    shimmerBase: const Color(0xFFE0E0E0),
    shimmerHighlight: const Color(0xFFF5F5F5),
  );

  static AppThemeExtension dark = AppThemeExtension(
    brandPrimary: AppColors.dark.primary,
    brandSecondary: AppColors.dark.secondary,
    success: AppColors.dark.tertiary,
    warning: const Color(0xFFFFB74D),
    info: AppColors.dark.secondary,
    cardBackground: AppColors.dark.surfaceContainerHighest,
    divider: AppColors.dark.outlineVariant,
    shimmerBase: const Color(0xFF424242),
    shimmerHighlight: const Color(0xFF616161),
  );

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? brandPrimary,
    Color? brandSecondary,
    Color? success,
    Color? warning,
    Color? info,
    Color? cardBackground,
    Color? divider,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return AppThemeExtension(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      cardBackground: cardBackground ?? this.cardBackground,
      divider: divider ?? this.divider,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(
        shimmerHighlight,
        other.shimmerHighlight,
        t,
      )!,
    );
  }
}

extension AppThemeExtensionContext on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;
}

extension AppTextThemeContext on BuildContext {
  TextTheme get appTextTheme => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
