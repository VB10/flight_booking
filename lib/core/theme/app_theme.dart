import 'package:flight_booking/core/theme/app_color_scheme.dart';
import 'package:flight_booking/core/theme/app_text_styles.dart';
import 'package:flight_booking/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

final class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final scheme = AppColorScheme.light;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: AppTextStyles.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      fontFamily: 'Roboto',
      extensions: <ThemeExtension<dynamic>>[
        AppThemeExtension.light,
      ],
    );
  }

  static ThemeData get darkTheme {
    final scheme = AppColorScheme.dark;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: AppTextStyles.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      fontFamily: 'Roboto',
      extensions: <ThemeExtension<dynamic>>[
        AppThemeExtension.dark,
      ],
    );
  }
}
