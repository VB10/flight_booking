// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductErrorModel _$ProductErrorModelFromJson(Map<String, dynamic> json) =>
    ProductErrorModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      errorCode: json['errorCode'] as String?,
      details: json['details'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ProductErrorModelToJson(ProductErrorModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': ?instance.message,
      'errorCode': ?instance.errorCode,
      'details': ?instance.details,
    };
