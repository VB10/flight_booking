import 'package:flight_booking/feature/auth/profile/profile_response_model.dart';
import 'package:flight_booking/feature/unauth/login/model/login_response_model.dart';
import 'package:flight_booking/product/network/error_model.dart';
import 'package:vexana/vexana.dart';

/// Abstract interface for authentication-related operations
abstract interface class IAuthService {
  /// Login with email and password
  Future<NetworkResult<LoginResponseModel, ProductErrorModel>> login({
    required String email,
    required String password,
  });

  /// Get user profile
  Future<NetworkResult<ProfileResponseModel, ProductErrorModel>> getProfile();
}
