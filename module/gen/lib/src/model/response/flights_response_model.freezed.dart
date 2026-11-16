// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flights_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlightsResponseModel {

 bool get success; List<FlightModel> get data; String get message;
/// Create a copy of FlightsResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlightsResponseModelCopyWith<FlightsResponseModel> get copyWith => _$FlightsResponseModelCopyWithImpl<FlightsResponseModel>(this as FlightsResponseModel, _$identity);

  /// Serializes this FlightsResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlightsResponseModel&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(data),message);

@override
String toString() {
  return 'FlightsResponseModel(success: $success, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class $FlightsResponseModelCopyWith<$Res>  {
  factory $FlightsResponseModelCopyWith(FlightsResponseModel value, $Res Function(FlightsResponseModel) _then) = _$FlightsResponseModelCopyWithImpl;
@useResult
$Res call({
 bool success, List<FlightModel> data, String message
});




}
/// @nodoc
class _$FlightsResponseModelCopyWithImpl<$Res>
    implements $FlightsResponseModelCopyWith<$Res> {
  _$FlightsResponseModelCopyWithImpl(this._self, this._then);

  final FlightsResponseModel _self;
  final $Res Function(FlightsResponseModel) _then;

/// Create a copy of FlightsResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,Object? message = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<FlightModel>,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FlightsResponseModel].
extension FlightsResponseModelPatterns on FlightsResponseModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlightsResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlightsResponseModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlightsResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _FlightsResponseModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlightsResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _FlightsResponseModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  List<FlightModel> data,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlightsResponseModel() when $default != null:
return $default(_that.success,_that.data,_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  List<FlightModel> data,  String message)  $default,) {final _that = this;
switch (_that) {
case _FlightsResponseModel():
return $default(_that.success,_that.data,_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  List<FlightModel> data,  String message)?  $default,) {final _that = this;
switch (_that) {
case _FlightsResponseModel() when $default != null:
return $default(_that.success,_that.data,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FlightsResponseModel extends FlightsResponseModel {
  const _FlightsResponseModel({required this.success, required final  List<FlightModel> data, required this.message}): _data = data,super._();
  factory _FlightsResponseModel.fromJson(Map<String, dynamic> json) => _$FlightsResponseModelFromJson(json);

@override final  bool success;
 final  List<FlightModel> _data;
@override List<FlightModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  String message;

/// Create a copy of FlightsResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlightsResponseModelCopyWith<_FlightsResponseModel> get copyWith => __$FlightsResponseModelCopyWithImpl<_FlightsResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlightsResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlightsResponseModel&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(_data),message);

@override
String toString() {
  return 'FlightsResponseModel(success: $success, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class _$FlightsResponseModelCopyWith<$Res> implements $FlightsResponseModelCopyWith<$Res> {
  factory _$FlightsResponseModelCopyWith(_FlightsResponseModel value, $Res Function(_FlightsResponseModel) _then) = __$FlightsResponseModelCopyWithImpl;
@override @useResult
$Res call({
 bool success, List<FlightModel> data, String message
});




}
/// @nodoc
class __$FlightsResponseModelCopyWithImpl<$Res>
    implements _$FlightsResponseModelCopyWith<$Res> {
  __$FlightsResponseModelCopyWithImpl(this._self, this._then);

  final _FlightsResponseModel _self;
  final $Res Function(_FlightsResponseModel) _then;

/// Create a copy of FlightsResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,Object? message = null,}) {
  return _then(_FlightsResponseModel(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<FlightModel>,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$FlightModel {

 int get id; String get airline; String get from; String get to; String get departureTime; String get arrivalTime; int get price; String get duration; String get date;// NEW DATA (v13 design) — nullable so an older backend still parses.
/// IATA code of [from], e.g. "IST".
 String? get fromCode;/// IATA code of [to], e.g. "ESB".
 String? get toCode; String? get flightNumber; String? get aircraftType; String? get seatClass; String? get baggageAllowance;
/// Create a copy of FlightModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlightModelCopyWith<FlightModel> get copyWith => _$FlightModelCopyWithImpl<FlightModel>(this as FlightModel, _$identity);

  /// Serializes this FlightModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlightModel&&(identical(other.id, id) || other.id == id)&&(identical(other.airline, airline) || other.airline == airline)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.arrivalTime, arrivalTime) || other.arrivalTime == arrivalTime)&&(identical(other.price, price) || other.price == price)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.date, date) || other.date == date)&&(identical(other.fromCode, fromCode) || other.fromCode == fromCode)&&(identical(other.toCode, toCode) || other.toCode == toCode)&&(identical(other.flightNumber, flightNumber) || other.flightNumber == flightNumber)&&(identical(other.aircraftType, aircraftType) || other.aircraftType == aircraftType)&&(identical(other.seatClass, seatClass) || other.seatClass == seatClass)&&(identical(other.baggageAllowance, baggageAllowance) || other.baggageAllowance == baggageAllowance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,airline,from,to,departureTime,arrivalTime,price,duration,date,fromCode,toCode,flightNumber,aircraftType,seatClass,baggageAllowance);

@override
String toString() {
  return 'FlightModel(id: $id, airline: $airline, from: $from, to: $to, departureTime: $departureTime, arrivalTime: $arrivalTime, price: $price, duration: $duration, date: $date, fromCode: $fromCode, toCode: $toCode, flightNumber: $flightNumber, aircraftType: $aircraftType, seatClass: $seatClass, baggageAllowance: $baggageAllowance)';
}


}

/// @nodoc
abstract mixin class $FlightModelCopyWith<$Res>  {
  factory $FlightModelCopyWith(FlightModel value, $Res Function(FlightModel) _then) = _$FlightModelCopyWithImpl;
@useResult
$Res call({
 int id, String airline, String from, String to, String departureTime, String arrivalTime, int price, String duration, String date, String? fromCode, String? toCode, String? flightNumber, String? aircraftType, String? seatClass, String? baggageAllowance
});




}
/// @nodoc
class _$FlightModelCopyWithImpl<$Res>
    implements $FlightModelCopyWith<$Res> {
  _$FlightModelCopyWithImpl(this._self, this._then);

  final FlightModel _self;
  final $Res Function(FlightModel) _then;

/// Create a copy of FlightModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? airline = null,Object? from = null,Object? to = null,Object? departureTime = null,Object? arrivalTime = null,Object? price = null,Object? duration = null,Object? date = null,Object? fromCode = freezed,Object? toCode = freezed,Object? flightNumber = freezed,Object? aircraftType = freezed,Object? seatClass = freezed,Object? baggageAllowance = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,airline: null == airline ? _self.airline : airline // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,departureTime: null == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String,arrivalTime: null == arrivalTime ? _self.arrivalTime : arrivalTime // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,fromCode: freezed == fromCode ? _self.fromCode : fromCode // ignore: cast_nullable_to_non_nullable
as String?,toCode: freezed == toCode ? _self.toCode : toCode // ignore: cast_nullable_to_non_nullable
as String?,flightNumber: freezed == flightNumber ? _self.flightNumber : flightNumber // ignore: cast_nullable_to_non_nullable
as String?,aircraftType: freezed == aircraftType ? _self.aircraftType : aircraftType // ignore: cast_nullable_to_non_nullable
as String?,seatClass: freezed == seatClass ? _self.seatClass : seatClass // ignore: cast_nullable_to_non_nullable
as String?,baggageAllowance: freezed == baggageAllowance ? _self.baggageAllowance : baggageAllowance // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FlightModel].
extension FlightModelPatterns on FlightModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlightModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlightModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlightModel value)  $default,){
final _that = this;
switch (_that) {
case _FlightModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlightModel value)?  $default,){
final _that = this;
switch (_that) {
case _FlightModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String airline,  String from,  String to,  String departureTime,  String arrivalTime,  int price,  String duration,  String date,  String? fromCode,  String? toCode,  String? flightNumber,  String? aircraftType,  String? seatClass,  String? baggageAllowance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlightModel() when $default != null:
return $default(_that.id,_that.airline,_that.from,_that.to,_that.departureTime,_that.arrivalTime,_that.price,_that.duration,_that.date,_that.fromCode,_that.toCode,_that.flightNumber,_that.aircraftType,_that.seatClass,_that.baggageAllowance);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String airline,  String from,  String to,  String departureTime,  String arrivalTime,  int price,  String duration,  String date,  String? fromCode,  String? toCode,  String? flightNumber,  String? aircraftType,  String? seatClass,  String? baggageAllowance)  $default,) {final _that = this;
switch (_that) {
case _FlightModel():
return $default(_that.id,_that.airline,_that.from,_that.to,_that.departureTime,_that.arrivalTime,_that.price,_that.duration,_that.date,_that.fromCode,_that.toCode,_that.flightNumber,_that.aircraftType,_that.seatClass,_that.baggageAllowance);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String airline,  String from,  String to,  String departureTime,  String arrivalTime,  int price,  String duration,  String date,  String? fromCode,  String? toCode,  String? flightNumber,  String? aircraftType,  String? seatClass,  String? baggageAllowance)?  $default,) {final _that = this;
switch (_that) {
case _FlightModel() when $default != null:
return $default(_that.id,_that.airline,_that.from,_that.to,_that.departureTime,_that.arrivalTime,_that.price,_that.duration,_that.date,_that.fromCode,_that.toCode,_that.flightNumber,_that.aircraftType,_that.seatClass,_that.baggageAllowance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FlightModel extends FlightModel {
  const _FlightModel({required this.id, required this.airline, required this.from, required this.to, required this.departureTime, required this.arrivalTime, required this.price, required this.duration, required this.date, this.fromCode, this.toCode, this.flightNumber, this.aircraftType, this.seatClass, this.baggageAllowance}): super._();
  factory _FlightModel.fromJson(Map<String, dynamic> json) => _$FlightModelFromJson(json);

@override final  int id;
@override final  String airline;
@override final  String from;
@override final  String to;
@override final  String departureTime;
@override final  String arrivalTime;
@override final  int price;
@override final  String duration;
@override final  String date;
// NEW DATA (v13 design) — nullable so an older backend still parses.
/// IATA code of [from], e.g. "IST".
@override final  String? fromCode;
/// IATA code of [to], e.g. "ESB".
@override final  String? toCode;
@override final  String? flightNumber;
@override final  String? aircraftType;
@override final  String? seatClass;
@override final  String? baggageAllowance;

/// Create a copy of FlightModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlightModelCopyWith<_FlightModel> get copyWith => __$FlightModelCopyWithImpl<_FlightModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlightModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlightModel&&(identical(other.id, id) || other.id == id)&&(identical(other.airline, airline) || other.airline == airline)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.arrivalTime, arrivalTime) || other.arrivalTime == arrivalTime)&&(identical(other.price, price) || other.price == price)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.date, date) || other.date == date)&&(identical(other.fromCode, fromCode) || other.fromCode == fromCode)&&(identical(other.toCode, toCode) || other.toCode == toCode)&&(identical(other.flightNumber, flightNumber) || other.flightNumber == flightNumber)&&(identical(other.aircraftType, aircraftType) || other.aircraftType == aircraftType)&&(identical(other.seatClass, seatClass) || other.seatClass == seatClass)&&(identical(other.baggageAllowance, baggageAllowance) || other.baggageAllowance == baggageAllowance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,airline,from,to,departureTime,arrivalTime,price,duration,date,fromCode,toCode,flightNumber,aircraftType,seatClass,baggageAllowance);

@override
String toString() {
  return 'FlightModel(id: $id, airline: $airline, from: $from, to: $to, departureTime: $departureTime, arrivalTime: $arrivalTime, price: $price, duration: $duration, date: $date, fromCode: $fromCode, toCode: $toCode, flightNumber: $flightNumber, aircraftType: $aircraftType, seatClass: $seatClass, baggageAllowance: $baggageAllowance)';
}


}

/// @nodoc
abstract mixin class _$FlightModelCopyWith<$Res> implements $FlightModelCopyWith<$Res> {
  factory _$FlightModelCopyWith(_FlightModel value, $Res Function(_FlightModel) _then) = __$FlightModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String airline, String from, String to, String departureTime, String arrivalTime, int price, String duration, String date, String? fromCode, String? toCode, String? flightNumber, String? aircraftType, String? seatClass, String? baggageAllowance
});




}
/// @nodoc
class __$FlightModelCopyWithImpl<$Res>
    implements _$FlightModelCopyWith<$Res> {
  __$FlightModelCopyWithImpl(this._self, this._then);

  final _FlightModel _self;
  final $Res Function(_FlightModel) _then;

/// Create a copy of FlightModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? airline = null,Object? from = null,Object? to = null,Object? departureTime = null,Object? arrivalTime = null,Object? price = null,Object? duration = null,Object? date = null,Object? fromCode = freezed,Object? toCode = freezed,Object? flightNumber = freezed,Object? aircraftType = freezed,Object? seatClass = freezed,Object? baggageAllowance = freezed,}) {
  return _then(_FlightModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,airline: null == airline ? _self.airline : airline // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,departureTime: null == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String,arrivalTime: null == arrivalTime ? _self.arrivalTime : arrivalTime // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,fromCode: freezed == fromCode ? _self.fromCode : fromCode // ignore: cast_nullable_to_non_nullable
as String?,toCode: freezed == toCode ? _self.toCode : toCode // ignore: cast_nullable_to_non_nullable
as String?,flightNumber: freezed == flightNumber ? _self.flightNumber : flightNumber // ignore: cast_nullable_to_non_nullable
as String?,aircraftType: freezed == aircraftType ? _self.aircraftType : aircraftType // ignore: cast_nullable_to_non_nullable
as String?,seatClass: freezed == seatClass ? _self.seatClass : seatClass // ignore: cast_nullable_to_non_nullable
as String?,baggageAllowance: freezed == baggageAllowance ? _self.baggageAllowance : baggageAllowance // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
