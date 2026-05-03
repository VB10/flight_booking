import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
final class ApplicationState extends Equatable {
  const ApplicationState({required this.themeMode});

  final ThemeMode themeMode;

  ApplicationState copyWith({ThemeMode? themeMode}) {
    return ApplicationState(themeMode: themeMode ?? this.themeMode);
  }

  @override
  List<Object?> get props => [themeMode];
}
