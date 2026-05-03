import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'checkout_response_model.g.dart';

@JsonSerializable()
final class CheckoutResponseModel extends Equatable
    implements INetworkModel<CheckoutResponseModel> {
  const CheckoutResponseModel({
    required this.success,
    required this.message,
    required this.orderId,
    required this.totalPrice,
  });

  factory CheckoutResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutResponseModelFromJson(json);

  final bool success;
  final String message;
  final int orderId;
  final int totalPrice;

  @override
  CheckoutResponseModel fromJson(Map<String, dynamic> json) =>
      CheckoutResponseModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CheckoutResponseModelToJson(this);

  @override
  List<Object?> get props => [success, message, orderId, totalPrice];
}
