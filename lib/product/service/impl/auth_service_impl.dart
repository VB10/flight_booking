import 'package:flight_booking/product/network/network_constants.dart';
import 'package:flight_booking/product/network/network_manager.dart';
import 'package:flight_booking/product/network/product_network_manager.dart';
import 'package:flight_booking/product/service/auth_service.dart';
import 'package:gen/gen.dart';
import 'package:vexana/vexana.dart';

/// Concrete implementation of auth service
final class AuthServiceImpl implements IAuthService {
  AuthServiceImpl([IProductNetworkManager? networkManager])
    : _networkManager = networkManager ?? ProductNetworkManager.instance;

  final IProductNetworkManager _networkManager;

  @override
  Future<NetworkResult<LoginResponseModel, ProductErrorModel>> login(
    LoginRequestModel request,
  ) {
    return _networkManager.sendRequest<LoginResponseModel, LoginResponseModel>(
      NetworkPaths.login,
      parseModel: const LoginResponseModel(
        success: false,
        message: '',
        token: '',
        user: UserModel(id: 0, email: '', name: ''),
      ),
      method: RequestType.POST,
      body: request.toJson(),
    );
  }

  @override
  Future<NetworkResult<ProfileResponseModel, ProductErrorModel>> getProfile() {
    return _networkManager
        .sendRequest<ProfileResponseModel, ProfileResponseModel>(
          NetworkPaths.profile,
          parseModel: const ProfileResponseModel(
            success: false,
            data: ProfileData(
              id: 0,
              email: '',
              name: '',
              joinDate: '',
              totalBookings: 0,
              membershipLevel: '',
            ),
            message: '',
          ),
          method: RequestType.GET,
        );
  }
}
