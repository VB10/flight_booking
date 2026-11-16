// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CheckoutRequestModel _$CheckoutRequestModelFromJson(
  Map<String, dynamic> json,
) => _CheckoutRequestModel(
  cartItems: (json['cartItems'] as List<dynamic>)
      .map((e) => FlightModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  userEmail: json['userEmail'] as String,
);

Map<String, dynamic> _$CheckoutRequestModelToJson(
  _CheckoutRequestModel instance,
) => <String, dynamic>{
  'cartItems': instance.cartItems.map((e) => e.toJson()).toList(),
  'userEmail': instance.userEmail,
};
