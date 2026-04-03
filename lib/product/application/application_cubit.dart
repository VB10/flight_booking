import 'package:flight_booking/product/application/application_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit()
      : super(const ApplicationState(themeMode: ThemeMode.light));

  void toggleTheme() {
    final next = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(state.copyWith(themeMode: next));
  }
}
