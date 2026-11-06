import 'package:equatable/equatable.dart';
import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';
import 'package:flutter/foundation.dart';

@immutable
final class CartState extends Equatable {
  const CartState({this.items = const []});

  final List<FlightModel> items;

  int get count => items.length;
  bool get isEmpty => items.isEmpty;
  int get totalPrice => items.fold(0, (sum, f) => sum + f.price);

  CartState copyWith({List<FlightModel>? items}) =>
      CartState(items: items ?? this.items);

  @override
  List<Object?> get props => [items];
}
