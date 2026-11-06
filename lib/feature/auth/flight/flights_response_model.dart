import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'flights_response_model.g.dart';

@JsonSerializable()
final class FlightsResponseModel extends Equatable
    implements INetworkModel<FlightsResponseModel> {
  const FlightsResponseModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory FlightsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FlightsResponseModelFromJson(json);

  final bool success;
  final List<FlightModel> data;
  final String message;

  @override
  FlightsResponseModel fromJson(Map<String, dynamic> json) =>
      FlightsResponseModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FlightsResponseModelToJson(this);

  @override
  List<Object?> get props => [success, data, message];
}

@JsonSerializable()
final class FlightModel extends Equatable
    implements INetworkModel<FlightModel> {
  const FlightModel({
    required this.id,
    required this.airline,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.duration,
    required this.date,
    this.fromCode,
    this.toCode,
    this.flightNumber,
    this.aircraftType,
    this.seatClass,
    this.baggageAllowance,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) =>
      _$FlightModelFromJson(json);

  final int id;
  final String airline;
  final String from;
  final String to;
  final String departureTime;
  final String arrivalTime;
  final int price;
  final String duration;
  final String date;

  // NEW DATA (v13 design) — nullable so an older backend still parses.
  /// IATA code of [from], e.g. "IST".
  final String? fromCode;

  /// IATA code of [to], e.g. "ESB".
  final String? toCode;
  final String? flightNumber;
  final String? aircraftType;
  final String? seatClass;
  final String? baggageAllowance;

  @override
  FlightModel fromJson(Map<String, dynamic> json) => FlightModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FlightModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    airline,
    from,
    to,
    departureTime,
    arrivalTime,
    price,
    duration,
    date,
    fromCode,
    toCode,
    flightNumber,
    aircraftType,
    seatClass,
    baggageAllowance,
  ];
}
