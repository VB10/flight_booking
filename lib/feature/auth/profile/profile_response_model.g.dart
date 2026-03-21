// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponseModel _$ProfileResponseModelFromJson(
  Map<String, dynamic> json,
) => ProfileResponseModel(
  success: json['success'] as bool,
  data: ProfileData.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String,
);

Map<String, dynamic> _$ProfileResponseModelToJson(
  ProfileResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.toJson(),
  'message': instance.message,
};

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  name: json['name'] as String,
  joinDate: json['joinDate'] as String,
  totalBookings: (json['totalBookings'] as num).toInt(),
  membershipLevel: json['membershipLevel'] as String,
);

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'joinDate': instance.joinDate,
      'totalBookings': instance.totalBookings,
      'membershipLevel': instance.membershipLevel,
    };
