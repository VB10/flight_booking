// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flights_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlightsResponseModel _$FlightsResponseModelFromJson(
  Map<String, dynamic> json,
) => FlightsResponseModel(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => FlightModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] as String,
);

Map<String, dynamic> _$FlightsResponseModelToJson(
  FlightsResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
  'message': instance.message,
};

FlightModel _$FlightModelFromJson(Map<String, dynamic> json) => FlightModel(
  id: (json['id'] as num).toInt(),
  airline: json['airline'] as String,
  from: json['from'] as String,
  to: json['to'] as String,
  departureTime: json['departureTime'] as String,
  arrivalTime: json['arrivalTime'] as String,
  price: (json['price'] as num).toInt(),
  duration: json['duration'] as String,
  date: json['date'] as String,
);

Map<String, dynamic> _$FlightModelToJson(FlightModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'airline': instance.airline,
      'from': instance.from,
      'to': instance.to,
      'departureTime': instance.departureTime,
      'arrivalTime': instance.arrivalTime,
      'price': instance.price,
      'duration': instance.duration,
      'date': instance.date,
    };
