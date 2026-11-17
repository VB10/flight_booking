import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vexana/vexana.dart';

part 'checkout_response_model.freezed.dart';
part 'checkout_response_model.g.dart';

@freezed
abstract class CheckoutResponseModel
    with _$CheckoutResponseModel
    implements INetworkModel<CheckoutResponseModel> {
  const factory CheckoutResponseModel({
    required bool success,
    required String message,
    required int orderId,
    required int totalPrice,

    /// NEW DATA (v13 design): e.g. "FB-7K2M9Q", shown on the confirmation.
    String? bookingReference,
  }) = _CheckoutResponseModel;

  const CheckoutResponseModel._();

  factory CheckoutResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutResponseModelFromJson(json);

  @override
  CheckoutResponseModel fromJson(Map<String, dynamic> json) =>
      CheckoutResponseModel.fromJson(json);
}
