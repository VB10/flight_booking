// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutResponseModel _$CheckoutResponseModelFromJson(
  Map<String, dynamic> json,
) => CheckoutResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  orderId: (json['orderId'] as num).toInt(),
  totalPrice: (json['totalPrice'] as num).toInt(),
);

Map<String, dynamic> _$CheckoutResponseModelToJson(
  CheckoutResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'orderId': instance.orderId,
  'totalPrice': instance.totalPrice,
};
