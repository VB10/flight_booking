import 'package:flutter/material.dart';

/// Supported app languages — the single place a language is declared.
///
/// Adding a language = one enum entry + one `assets/translations/<code>.json`.
enum Locales {
  tr(Locale('tr', 'TR')),
  en(Locale('en', 'US'));

  const Locales(this.locale);

  /// Flutter locale used by `MaterialApp` and the localization package.
  final Locale locale;

  /// Two letter code; also the translation file name (`tr.json`).
  String get code => locale.languageCode;

  /// Cached/stored code back to an enum value. `null` when unknown, so the
  /// app can fall back to the device locale.
  static Locales? fromCodeOrNull(String? code) {
    if (code == null) return null;
    for (final item in Locales.values) {
      if (item.code == code) return item;
    }
    return null;
  }

  /// The next language in the list — used by the in-app language toggle.
  Locales get next => Locales.values[(index + 1) % Locales.values.length];
}
