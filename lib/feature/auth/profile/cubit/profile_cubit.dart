import 'package:flight_booking/feature/auth/profile/cubit/profile_state.dart';
import 'package:flight_booking/product/service/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Loads the signed-in user's profile. [load] is also the refresh / retry.
final class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authService) : super(const ProfileState());

  final IAuthService _authService;

  Future<void> load() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _authService.getProfile();
    if (isClosed) return;
    var failed = true;
    result.fold(
      onSuccess: (response) {
        if (!response.success) return;
        failed = false;
        emit(
          ProfileState(status: ProfileStatus.success, profile: response.data),
        );
      },
      onError: (_) {},
    );
    if (failed) emit(state.copyWith(status: ProfileStatus.failure));
  }
}
