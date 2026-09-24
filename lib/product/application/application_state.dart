import 'package:equatable/equatable.dart';
import 'package:flight_booking/product/localization/locales.dart';
import 'package:flutter/material.dart';

@immutable
final class ApplicationState extends Equatable {
  const ApplicationState({required this.themeMode, required this.locale});

  final ThemeMode themeMode;
  final Locales locale;

  ApplicationState copyWith({ThemeMode? themeMode, Locales? locale}) {
    return ApplicationState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale];
}
