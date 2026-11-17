import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vexana/vexana.dart';

part 'profile_response_model.freezed.dart';
part 'profile_response_model.g.dart';

@freezed
abstract class ProfileResponseModel
    with _$ProfileResponseModel
    implements INetworkModel<ProfileResponseModel> {
  const factory ProfileResponseModel({
    required bool success,
    required ProfileData data,
    required String message,
  }) = _ProfileResponseModel;

  const ProfileResponseModel._();

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelFromJson(json);

  @override
  ProfileResponseModel fromJson(Map<String, dynamic> json) =>
      ProfileResponseModel.fromJson(json);
}

@freezed
abstract class ProfileData
    with _$ProfileData
    implements INetworkModel<ProfileData> {
  const factory ProfileData({
    required int id,
    required String email,
    required String name,
    required String joinDate,
    required int totalBookings,
    required String membershipLevel,
  }) = _ProfileData;

  const ProfileData._();

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  @override
  ProfileData fromJson(Map<String, dynamic> json) => ProfileData.fromJson(json);
}
