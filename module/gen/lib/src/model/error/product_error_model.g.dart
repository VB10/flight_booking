// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductErrorModel _$ProductErrorModelFromJson(Map<String, dynamic> json) =>
    _ProductErrorModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      errorCode: json['errorCode'] as String?,
      details: json['details'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ProductErrorModelToJson(_ProductErrorModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': ?instance.message,
      'errorCode': ?instance.errorCode,
      'details': ?instance.details,
    };
