// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CheckoutResponseModel {

 bool get success; String get message; int get orderId; int get totalPrice;/// NEW DATA (v13 design): e.g. "FB-7K2M9Q", shown on the confirmation.
 String? get bookingReference;
/// Create a copy of CheckoutResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutResponseModelCopyWith<CheckoutResponseModel> get copyWith => _$CheckoutResponseModelCopyWithImpl<CheckoutResponseModel>(this as CheckoutResponseModel, _$identity);

  /// Serializes this CheckoutResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutResponseModel&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.bookingReference, bookingReference) || other.bookingReference == bookingReference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,orderId,totalPrice,bookingReference);

@override
String toString() {
  return 'CheckoutResponseModel(success: $success, message: $message, orderId: $orderId, totalPrice: $totalPrice, bookingReference: $bookingReference)';
}


}

/// @nodoc
abstract mixin class $CheckoutResponseModelCopyWith<$Res>  {
  factory $CheckoutResponseModelCopyWith(CheckoutResponseModel value, $Res Function(CheckoutResponseModel) _then) = _$CheckoutResponseModelCopyWithImpl;
@useResult
$Res call({
 bool success, String message, int orderId, int totalPrice, String? bookingReference
});




}
/// @nodoc
class _$CheckoutResponseModelCopyWithImpl<$Res>
    implements $CheckoutResponseModelCopyWith<$Res> {
  _$CheckoutResponseModelCopyWithImpl(this._self, this._then);

  final CheckoutResponseModel _self;
  final $Res Function(CheckoutResponseModel) _then;

/// Create a copy of CheckoutResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? orderId = null,Object? totalPrice = null,Object? bookingReference = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as int,bookingReference: freezed == bookingReference ? _self.bookingReference : bookingReference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckoutResponseModel].
extension CheckoutResponseModelPatterns on CheckoutResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  int orderId,  int totalPrice,  String? bookingReference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutResponseModel() when $default != null:
return $default(_that.success,_that.message,_that.orderId,_that.totalPrice,_that.bookingReference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  int orderId,  int totalPrice,  String? bookingReference)  $default,) {final _that = this;
switch (_that) {
case _CheckoutResponseModel():
return $default(_that.success,_that.message,_that.orderId,_that.totalPrice,_that.bookingReference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  int orderId,  int totalPrice,  String? bookingReference)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutResponseModel() when $default != null:
return $default(_that.success,_that.message,_that.orderId,_that.totalPrice,_that.bookingReference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckoutResponseModel extends CheckoutResponseModel {
  const _CheckoutResponseModel({required this.success, required this.message, required this.orderId, required this.totalPrice, this.bookingReference}): super._();
  factory _CheckoutResponseModel.fromJson(Map<String, dynamic> json) => _$CheckoutResponseModelFromJson(json);

@override final  bool success;
@override final  String message;
@override final  int orderId;
@override final  int totalPrice;
/// NEW DATA (v13 design): e.g. "FB-7K2M9Q", shown on the confirmation.
@override final  String? bookingReference;

/// Create a copy of CheckoutResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutResponseModelCopyWith<_CheckoutResponseModel> get copyWith => __$CheckoutResponseModelCopyWithImpl<_CheckoutResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckoutResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutResponseModel&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.bookingReference, bookingReference) || other.bookingReference == bookingReference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,orderId,totalPrice,bookingReference);

@override
String toString() {
  return 'CheckoutResponseModel(success: $success, message: $message, orderId: $orderId, totalPrice: $totalPrice, bookingReference: $bookingReference)';
}


}

/// @nodoc
abstract mixin class _$CheckoutResponseModelCopyWith<$Res> implements $CheckoutResponseModelCopyWith<$Res> {
  factory _$CheckoutResponseModelCopyWith(_CheckoutResponseModel value, $Res Function(_CheckoutResponseModel) _then) = __$CheckoutResponseModelCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, int orderId, int totalPrice, String? bookingReference
});




}
/// @nodoc
class __$CheckoutResponseModelCopyWithImpl<$Res>
    implements _$CheckoutResponseModelCopyWith<$Res> {
  __$CheckoutResponseModelCopyWithImpl(this._self, this._then);

  final _CheckoutResponseModel _self;
  final $Res Function(_CheckoutResponseModel) _then;

/// Create a copy of CheckoutResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? orderId = null,Object? totalPrice = null,Object? bookingReference = freezed,}) {
  return _then(_CheckoutResponseModel(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as int,bookingReference: freezed == bookingReference ? _self.bookingReference : bookingReference // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
