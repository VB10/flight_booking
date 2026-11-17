import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vexana/vexana.dart';

part 'flights_response_model.freezed.dart';
part 'flights_response_model.g.dart';

@freezed
abstract class FlightsResponseModel
    with _$FlightsResponseModel
    implements INetworkModel<FlightsResponseModel> {
  const factory FlightsResponseModel({
    required bool success,
    required List<FlightModel> data,
    required String message,
  }) = _FlightsResponseModel;

  const FlightsResponseModel._();

  factory FlightsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FlightsResponseModelFromJson(json);

  @override
  FlightsResponseModel fromJson(Map<String, dynamic> json) =>
      FlightsResponseModel.fromJson(json);
}

@freezed
abstract class FlightModel
    with _$FlightModel
    implements INetworkModel<FlightModel> {
  const factory FlightModel({
    required int id,
    required String airline,
    required String from,
    required String to,
    required String departureTime,
    required String arrivalTime,
    required int price,
    required String duration,
    required String date,

    // NEW DATA (v13 design) — nullable so an older backend still parses.
    /// IATA code of [from], e.g. "IST".
    String? fromCode,

    /// IATA code of [to], e.g. "ESB".
    String? toCode,
    String? flightNumber,
    String? aircraftType,
    String? seatClass,
    String? baggageAllowance,
  }) = _FlightModel;

  const FlightModel._();

  factory FlightModel.fromJson(Map<String, dynamic> json) =>
      _$FlightModelFromJson(json);

  @override
  FlightModel fromJson(Map<String, dynamic> json) => FlightModel.fromJson(json);
}
