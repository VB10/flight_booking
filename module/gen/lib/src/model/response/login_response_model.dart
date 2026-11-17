import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vexana/vexana.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

@freezed
abstract class LoginResponseModel
    with _$LoginResponseModel
    implements INetworkModel<LoginResponseModel> {
  const factory LoginResponseModel({
    required bool success,
    required String message,
    required String token,
    required UserModel user,
  }) = _LoginResponseModel;

  const LoginResponseModel._();

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  @override
  LoginResponseModel fromJson(Map<String, dynamic> json) =>
      LoginResponseModel.fromJson(json);
}

@freezed
abstract class UserModel with _$UserModel implements INetworkModel<UserModel> {
  const factory UserModel({
    required int id,
    required String email,
    required String name,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  UserModel fromJson(Map<String, dynamic> json) => UserModel.fromJson(json);
}
