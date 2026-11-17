import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:gen/src/model/response/flights_response_model.dart';

part 'checkout_request_model.freezed.dart';
part 'checkout_request_model.g.dart';

/// Body of `POST /checkout`: the cart items and the buyer's email.
@freezed
abstract class CheckoutRequestModel with _$CheckoutRequestModel {
  const factory CheckoutRequestModel({
    required List<FlightModel> cartItems,
    required String userEmail,
  }) = _CheckoutRequestModel;

  factory CheckoutRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutRequestModelFromJson(json);
}
