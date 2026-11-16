// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CheckoutRequestModel {

 List<FlightModel> get cartItems; String get userEmail;
/// Create a copy of CheckoutRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutRequestModelCopyWith<CheckoutRequestModel> get copyWith => _$CheckoutRequestModelCopyWithImpl<CheckoutRequestModel>(this as CheckoutRequestModel, _$identity);

  /// Serializes this CheckoutRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutRequestModel&&const DeepCollectionEquality().equals(other.cartItems, cartItems)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cartItems),userEmail);

@override
String toString() {
  return 'CheckoutRequestModel(cartItems: $cartItems, userEmail: $userEmail)';
}


}

/// @nodoc
abstract mixin class $CheckoutRequestModelCopyWith<$Res>  {
  factory $CheckoutRequestModelCopyWith(CheckoutRequestModel value, $Res Function(CheckoutRequestModel) _then) = _$CheckoutRequestModelCopyWithImpl;
@useResult
$Res call({
 List<FlightModel> cartItems, String userEmail
});




}
/// @nodoc
class _$CheckoutRequestModelCopyWithImpl<$Res>
    implements $CheckoutRequestModelCopyWith<$Res> {
  _$CheckoutRequestModelCopyWithImpl(this._self, this._then);

  final CheckoutRequestModel _self;
  final $Res Function(CheckoutRequestModel) _then;

/// Create a copy of CheckoutRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cartItems = null,Object? userEmail = null,}) {
  return _then(_self.copyWith(
cartItems: null == cartItems ? _self.cartItems : cartItems // ignore: cast_nullable_to_non_nullable
as List<FlightModel>,userEmail: null == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckoutRequestModel].
extension CheckoutRequestModelPatterns on CheckoutRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckoutRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckoutRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckoutRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _CheckoutRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckoutRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _CheckoutRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FlightModel> cartItems,  String userEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckoutRequestModel() when $default != null:
return $default(_that.cartItems,_that.userEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FlightModel> cartItems,  String userEmail)  $default,) {final _that = this;
switch (_that) {
case _CheckoutRequestModel():
return $default(_that.cartItems,_that.userEmail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FlightModel> cartItems,  String userEmail)?  $default,) {final _that = this;
switch (_that) {
case _CheckoutRequestModel() when $default != null:
return $default(_that.cartItems,_that.userEmail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckoutRequestModel implements CheckoutRequestModel {
  const _CheckoutRequestModel({required final  List<FlightModel> cartItems, required this.userEmail}): _cartItems = cartItems;
  factory _CheckoutRequestModel.fromJson(Map<String, dynamic> json) => _$CheckoutRequestModelFromJson(json);

 final  List<FlightModel> _cartItems;
@override List<FlightModel> get cartItems {
  if (_cartItems is EqualUnmodifiableListView) return _cartItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cartItems);
}

@override final  String userEmail;

/// Create a copy of CheckoutRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckoutRequestModelCopyWith<_CheckoutRequestModel> get copyWith => __$CheckoutRequestModelCopyWithImpl<_CheckoutRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckoutRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckoutRequestModel&&const DeepCollectionEquality().equals(other._cartItems, _cartItems)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cartItems),userEmail);

@override
String toString() {
  return 'CheckoutRequestModel(cartItems: $cartItems, userEmail: $userEmail)';
}


}

/// @nodoc
abstract mixin class _$CheckoutRequestModelCopyWith<$Res> implements $CheckoutRequestModelCopyWith<$Res> {
  factory _$CheckoutRequestModelCopyWith(_CheckoutRequestModel value, $Res Function(_CheckoutRequestModel) _then) = __$CheckoutRequestModelCopyWithImpl;
@override @useResult
$Res call({
 List<FlightModel> cartItems, String userEmail
});




}
/// @nodoc
class __$CheckoutRequestModelCopyWithImpl<$Res>
    implements _$CheckoutRequestModelCopyWith<$Res> {
  __$CheckoutRequestModelCopyWithImpl(this._self, this._then);

  final _CheckoutRequestModel _self;
  final $Res Function(_CheckoutRequestModel) _then;

/// Create a copy of CheckoutRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cartItems = null,Object? userEmail = null,}) {
  return _then(_CheckoutRequestModel(
cartItems: null == cartItems ? _self._cartItems : cartItems // ignore: cast_nullable_to_non_nullable
as List<FlightModel>,userEmail: null == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
