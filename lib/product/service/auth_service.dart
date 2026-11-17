import 'package:gen/gen.dart';
import 'package:vexana/vexana.dart';

/// Abstract interface for authentication-related operations
abstract interface class IAuthService {
  /// Login with email and password
  Future<NetworkResult<LoginResponseModel, ProductErrorModel>> login(
    LoginRequestModel request,
  );

  /// Get user profile
  Future<NetworkResult<ProfileResponseModel, ProductErrorModel>> getProfile();
}
