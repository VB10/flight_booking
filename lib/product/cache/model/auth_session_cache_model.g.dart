// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_cache_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSessionCacheModel _$AuthSessionCacheModelFromJson(
  Map<String, dynamic> json,
) => AuthSessionCacheModel(
  token: json['token'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  userId: (json['userId'] as num).toInt(),
);

Map<String, dynamic> _$AuthSessionCacheModelToJson(
  AuthSessionCacheModel instance,
) => <String, dynamic>{
  'token': instance.token,
  'email': instance.email,
  'name': instance.name,
  'userId': instance.userId,
};
