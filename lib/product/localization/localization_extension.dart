import 'package:easy_localization/easy_localization.dart';
import 'package:flight_booking/product/localization/locales.dart';
import 'package:flutter/material.dart';

/// Translates a `LocaleKeys` entry: `LocaleKeys.login_submit.translate`.
extension LocalizationExtension on String {
  /// Value for the active language.
  String get translate => tr(this);

  /// Value with positional `{}` placeholders filled in, in order.
  ///
  /// `"Süre: {}"` → `LocaleKeys.flight_duration.translateArgs([flight.duration])`
  String translateArgs(List<String> args) => tr(this, args: args);

  /// Value with named `{placeholder}` slots filled in. Prefer this over
  /// [translateArgs] when there is more than one value: the JSON stays
  /// readable and translators can reorder the sentence freely.
  ///
  /// `"Test hesabı: {email} / {password}"` →
  /// `key.translateNamed({'email': ..., 'password': ...})`
  String translateNamed(Map<String, String> namedArgs) =>
      tr(this, namedArgs: namedArgs);

  /// Value for a plural key — a JSON object with `zero`/`one`/`two`/`few`/
  /// `many`/`other` branches. The count replaces `{}` unless [name] is given,
  /// in which case it fills `{name}`.
  ///
  /// The branch is chosen by the active language's own plural rules, which is
  /// why a count must never be glued to a translated fragment by hand.
  String translatePlural(
    num value, {
    List<String>? args,
    Map<String, String>? namedArgs,
    String? name,
  }) => plural(this, value, args: args, namedArgs: namedArgs, name: name);
}

/// The localization plumbing `MaterialApp` needs, without leaking the package.
extension LocalizationContextExtension on BuildContext {
  /// Delegates for `MaterialApp.localizationsDelegates`.
  List<LocalizationsDelegate<dynamic>> get productDelegates =>
      EasyLocalization.of(this)!.delegates;

  /// Locales for `MaterialApp.supportedLocales`.
  List<Locale> get productSupportedLocales =>
      EasyLocalization.of(this)!.supportedLocales;

  /// Active locale for `MaterialApp.locale`.
  Locale get productLocale => EasyLocalization.of(this)!.locale;

  /// Active language as an app enum.
  Locales get appLocale =>
      Locales.fromCodeOrNull(productLocale.languageCode) ?? Locales.en;
}
