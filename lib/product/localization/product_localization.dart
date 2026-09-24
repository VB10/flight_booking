import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:flight_booking/product/localization/locales.dart';
import 'package:flutter/material.dart';

/// Wraps `easy_localization` so the rest of the app never imports it.
///
/// Same idea as the v11 cache layer: the package is an implementation detail
/// behind a product-owned facade. Pages talk to `LocaleKeys` + `.translate`,
/// `MaterialApp` talks to the context extensions in
/// `localization_extension.dart`, and nobody else knows which package is used.
final class ProductLocalization extends StatelessWidget {
  const ProductLocalization({required this.child, this.startLocale, super.key});

  /// Where the `<code>.json` files live (registered in `pubspec.yaml`).
  static const String _translationPath = 'assets/translations';

  final Widget child;

  /// Language restored from the cache; `null` → device locale, then
  /// [Locales.en] as fallback.
  final Locales? startLocale;

  /// Must run after `WidgetsFlutterBinding.ensureInitialized` and before
  /// `runApp`. Called by `AppInitializer`.
  static Future<void> init() async {
    // The package logs every lifecycle step at DEBUG/INFO — pure noise. Keep
    // the two levels that mean something: a missing key is a WARNING, a failed
    // asset load an ERROR. Release builds are silent by default.
    EasyLocalization.logger.enableLevels = <LevelMessages>[
      LevelMessages.error,
      LevelMessages.warning,
    ];
    await EasyLocalization.ensureInitialized();
  }

  /// Switch the active language. Persistence is the caller's job
  /// (`ApplicationCubit` writes it through `ICacheManager`).
  static Future<void> updateLanguage({
    required BuildContext context,
    required Locales value,
  }) => context.setLocale(value.locale);

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: Locales.values.map((item) => item.locale).toList(),
      path: _translationPath,
      fallbackLocale: Locales.en.locale,
      startLocale: startLocale?.locale,
      // The app owns persistence via ICacheManager (v11), not the package.
      saveLocale: false,
      useOnlyLangCode: true,
      child: child,
    );
  }
}
