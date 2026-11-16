import 'dart:math';

import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';
import 'package:flight_booking/product/application/cart/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// App-wide cart (v13). One instance in `ProductContainer`, shared by
/// Flights (badge + add), Flight detail (add), Cart (remove / undo / pay)
/// and the booking confirmation (clear).
///
/// Lives in memory only: the design has no "saved cart" requirement.
final class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  static final Random _random = Random.secure();

  /// Idempotency key of the payment attempt for the CURRENT cart content.
  /// Deliberately NOT in [CartState]: it is Equatable, so a lazy set would be
  /// dropped as "same state", and the badge / list must not rebuild for it.
  String? _checkoutKey;

  /// The same key for every try of the same cart (retry, reopened page); a new
  /// one as soon as the cart changes. The server uses it to replay the first
  /// order instead of creating a second one.
  String ensureCheckoutKey() => _checkoutKey ??= _newKey();

  static String _newKey() => List.generate(
    16,
    (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();

  @override
  void emit(CartState state) {
    _checkoutKey = null; // every cart mutation starts a new payment intent
    super.emit(state);
  }

  /// Every entry is its own instance — adding the same flight twice gives
  /// two entries the list can tell apart (`ObjectKey`), so removing one never
  /// confuses the other (swipe-to-dismiss relies on this).
  void add(FlightModel flight) => emit(
    state.copyWith(
      items: [...state.items, FlightModel.fromJson(flight.toJson())],
    ),
  );

  /// Removes the item at [index] and returns it, so the caller can offer
  /// "Undo" through [restore]. Returns `null` for an invalid index.
  FlightModel? removeAt(int index) {
    if (index < 0 || index >= state.items.length) return null;
    final items = [...state.items];
    final removed = items.removeAt(index);
    emit(state.copyWith(items: items));
    return removed;
  }

  /// Puts [flight] back at [index] (clamped) — the "Undo" of [removeAt].
  void restore(int index, FlightModel flight) {
    final items = [...state.items];
    items.insert(index.clamp(0, items.length), flight);
    emit(state.copyWith(items: items));
  }

  /// After a successful payment, and on log out.
  void clear() => emit(const CartState());
}
