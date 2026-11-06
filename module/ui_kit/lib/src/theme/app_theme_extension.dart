import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_colors.dart';

/// Semantic roles Material 3 does not have — read with `context.appTheme`.
@immutable
final class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
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
  });

  factory AppThemeExtension.fromPalette(AppPalette p) => AppThemeExtension(
    brandPrimary: p.brandPrimary,
    brandSecondary: p.brandSecondary,
    success: p.success,
    onSuccess: p.onSuccess,
    successContainer: p.successContainer,
    onSuccessContainer: p.onSuccessContainer,
    warning: p.warning,
    onWarning: p.onWarning,
    warningContainer: p.warningContainer,
    onWarningContainer: p.onWarningContainer,
    info: p.info,
    infoContainer: p.infoContainer,
    onInfoContainer: p.onInfoContainer,
    cardBackground: p.cardBackground,
    divider: p.divider,
    shimmerBase: p.shimmerBase,
    shimmerHighlight: p.shimmerHighlight,
  );

  static final AppThemeExtension light = AppThemeExtension.fromPalette(
    AppColors.light,
  );
  static final AppThemeExtension dark = AppThemeExtension.fromPalette(
    AppColors.dark,
  );

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

  @override
  AppThemeExtension copyWith({
    Color? brandPrimary,
    Color? brandSecondary,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? cardBackground,
    Color? divider,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return AppThemeExtension(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      cardBackground: cardBackground ?? this.cardBackground,
      divider: divider ?? this.divider,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppThemeExtension(
      brandPrimary: l(brandPrimary, other.brandPrimary),
      brandSecondary: l(brandSecondary, other.brandSecondary),
      success: l(success, other.success),
      onSuccess: l(onSuccess, other.onSuccess),
      successContainer: l(successContainer, other.successContainer),
      onSuccessContainer: l(onSuccessContainer, other.onSuccessContainer),
      warning: l(warning, other.warning),
      onWarning: l(onWarning, other.onWarning),
      warningContainer: l(warningContainer, other.warningContainer),
      onWarningContainer: l(onWarningContainer, other.onWarningContainer),
      info: l(info, other.info),
      infoContainer: l(infoContainer, other.infoContainer),
      onInfoContainer: l(onInfoContainer, other.onInfoContainer),
      cardBackground: l(cardBackground, other.cardBackground),
      divider: l(divider, other.divider),
      shimmerBase: l(shimmerBase, other.shimmerBase),
      shimmerHighlight: l(shimmerHighlight, other.shimmerHighlight),
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
