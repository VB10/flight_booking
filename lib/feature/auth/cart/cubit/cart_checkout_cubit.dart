import 'package:flight_booking/feature/auth/cart/cubit/cart_checkout_state.dart';
import 'package:flight_booking/product/application/auth/auth_cubit.dart';
import 'package:flight_booking/product/application/cart/cart_cubit.dart';
import 'package:flight_booking/product/service/flight_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Owns the payment of the app-wide cart: idle → processing → success / error.
final class CartCheckoutCubit extends Cubit<CartCheckoutState> {
  CartCheckoutCubit(this._flightService, this._cartCubit, this._authCubit)
    : super(const CartCheckoutState());

  final IFlightService _flightService;
  final CartCubit _cartCubit;
  final AuthCubit _authCubit;

  /// Pays for the current cart. Also the retry of the error state.
  Future<void> pay() async {
    final items = _cartCubit.state.items;
    if (state.isProcessing || items.isEmpty) return;

    emit(
      CartCheckoutState(
        status: CartCheckoutStatus.processing,
        paidItems: items,
      ),
    );
    final result = await _flightService.checkout(
      cartItems: items,
      userEmail: _authCubit.state.email ?? '',
    );
    // The order exists on the server once checkout succeeds: clear the
    // app-wide cart first, even if this page (and cubit) is already gone,
    // so the same tickets can never be paid twice.
    var paid = false;
    result.fold(
      onSuccess: (response) => paid = response.success,
      onError: (_) {},
    );
    if (paid) _cartCubit.clear();
    if (isClosed) return;

    result.fold(
      onSuccess: (response) {
        if (response.success) {
          emit(
            CartCheckoutState(
              status: CartCheckoutStatus.success,
              response: response,
              paidItems: items,
            ),
          );
        } else {
          emit(
            CartCheckoutState(
              status: CartCheckoutStatus.error,
              paidItems: items,
              errorMessage: response.message,
            ),
          );
        }
      },
      onError: (error) {
        emit(
          CartCheckoutState(
            status: CartCheckoutStatus.error,
            paidItems: items,
          ),
        );
      },
    );
  }
}
