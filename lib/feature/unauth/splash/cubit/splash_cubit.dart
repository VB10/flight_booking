import 'dart:async';

import 'package:flight_booking/feature/unauth/splash/cubit/splash_state.dart';
import 'package:flight_booking/product/application/auth/auth_cubit.dart';
import 'package:flight_booking/product/service/app_update_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._authCubit, this._updateService)
    : super(const SplashState());

  static const _splashDuration = Duration(seconds: 2);

  final AuthCubit _authCubit;
  final IAppUpdateService _updateService;

  /// Start-up: min splash time + session restore + forced-update check.
  Future<void> start() async {
    final results = await Future.wait<Object?>([
      Future<void>.delayed(_splashDuration),
      _authCubit.restoreSession(),
      _updateService.checkUpdate(),
    ]);
    if (isClosed) return;

    final update = results[2] as AppUpdateInfo?;
    if (update == null) {
      _ready();
      return;
    }
    emit(
      state.copyWith(
        status: SplashStatus.updateRequired,
        forceUpdate: update.forceUpdate,
        updateMessage: update.message,
      ),
    );
  }

  /// "Later" / "Update" closed the dialog: continue to Login or Flights.
  void continueAfterUpdate() => _ready();

  void _ready() {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: SplashStatus.ready,
        isLoggedIn: _authCubit.state.isLoggedIn,
      ),
    );
  }
}
