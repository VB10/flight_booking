import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'profile_response_model.g.dart';

@JsonSerializable()
final class ProfileResponseModel extends Equatable
    implements INetworkModel<ProfileResponseModel> {
  const ProfileResponseModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelFromJson(json);

  final bool success;
  final ProfileData data;
  final String message;

  @override
  ProfileResponseModel fromJson(Map<String, dynamic> json) =>
      ProfileResponseModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfileResponseModelToJson(this);

  @override
  List<Object?> get props => [success, data, message];
}

@JsonSerializable()
final class ProfileData extends Equatable
    implements INetworkModel<ProfileData> {
  const ProfileData({
    required this.id,
    required this.email,
    required this.name,
    required this.joinDate,
    required this.totalBookings,
    required this.membershipLevel,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  final int id;
  final String email;
  final String name;
  final String joinDate;
  final int totalBookings;
  final String membershipLevel;

  @override
  ProfileData fromJson(Map<String, dynamic> json) =>
      ProfileData.fromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        joinDate,
        totalBookings,
        membershipLevel,
      ];
}
