import 'package:equatable/equatable.dart';
import 'package:flight_booking/feature/auth/cart/checkout_response_model.dart';
import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';
import 'package:flutter/foundation.dart';

enum CartCheckoutStatus { idle, processing, success, error }

@immutable
final class CartCheckoutState extends Equatable {
  const CartCheckoutState({
    this.status = CartCheckoutStatus.idle,
    this.response,
    this.paidItems = const [],
    this.errorMessage = '',
  });

  final CartCheckoutStatus status;

  /// Set on success; carries `bookingReference` and the paid total.
  final CheckoutResponseModel? response;

  /// Copy of the cart at payment time, shown on the confirmation after the
  /// app-wide cart is cleared.
  final List<FlightModel> paidItems;

  /// Server / network failure text; empty means "use the default message".
  final String errorMessage;

  bool get isProcessing => status == CartCheckoutStatus.processing;

  CartCheckoutState copyWith({
    CartCheckoutStatus? status,
    CheckoutResponseModel? response,
    List<FlightModel>? paidItems,
    String? errorMessage,
  }) {
    return CartCheckoutState(
      status: status ?? this.status,
      response: response ?? this.response,
      paidItems: paidItems ?? this.paidItems,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, response, paidItems, errorMessage];
}
