import 'package:cache_manager/cache_manager.dart';
import 'package:flight_booking/product/application/application_state.dart';
import 'package:flight_booking/product/cache/product_cache_keys.dart';
import 'package:flight_booking/product/localization/locales.dart';
import 'package:flight_booking/product/localization/product_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// App-wide preferences: theme mode and language.
final class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit(ICacheManager cacheManager)
    : _cacheManager = cacheManager,
      super(
        ApplicationState(
          themeMode: ThemeMode.light,
          locale:
              Locales.fromCodeOrNull(
                cacheManager.readString(ProductCacheKeys.locale),
              ) ??
              Locales.en,
        ),
      );

  final ICacheManager _cacheManager;

  void toggleTheme() {
    final next = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(state.copyWith(themeMode: next));
  }

  /// Switch language and persist the choice through the v11 cache layer.
  Future<void> changeLocale({
    required BuildContext context,
    required Locales value,
  }) async {
    if (value == state.locale) return;
    await ProductLocalization.updateLanguage(context: context, value: value);
    await _cacheManager.writeString(ProductCacheKeys.locale, value.code);
    emit(state.copyWith(locale: value));
  }

  /// Toggle to the next supported language (used by the app bar button).
  Future<void> toggleLocale(BuildContext context) =>
      changeLocale(context: context, value: state.locale.next);
}
