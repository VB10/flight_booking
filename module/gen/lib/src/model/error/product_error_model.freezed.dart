// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_error_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductErrorModel {

/// Whether the request was successful (always false for errors)
 bool get success;/// Human-readable error message
 String? get message;/// Machine-readable error code for specific handling
 String? get errorCode;/// Additional error details (field errors, etc.)
 Map<String, dynamic>? get details;
/// Create a copy of ProductErrorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductErrorModelCopyWith<ProductErrorModel> get copyWith => _$ProductErrorModelCopyWithImpl<ProductErrorModel>(this as ProductErrorModel, _$identity);

  /// Serializes this ProductErrorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductErrorModel&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&const DeepCollectionEquality().equals(other.details, details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,errorCode,const DeepCollectionEquality().hash(details));



}

/// @nodoc
abstract mixin class $ProductErrorModelCopyWith<$Res>  {
  factory $ProductErrorModelCopyWith(ProductErrorModel value, $Res Function(ProductErrorModel) _then) = _$ProductErrorModelCopyWithImpl;
@useResult
$Res call({
 bool success, String? message, String? errorCode, Map<String, dynamic>? details
});




}
/// @nodoc
class _$ProductErrorModelCopyWithImpl<$Res>
    implements $ProductErrorModelCopyWith<$Res> {
  _$ProductErrorModelCopyWithImpl(this._self, this._then);

  final ProductErrorModel _self;
  final $Res Function(ProductErrorModel) _then;

/// Create a copy of ProductErrorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = freezed,Object? errorCode = freezed,Object? details = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductErrorModel].
extension ProductErrorModelPatterns on ProductErrorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductErrorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductErrorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductErrorModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductErrorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductErrorModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductErrorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String? message,  String? errorCode,  Map<String, dynamic>? details)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductErrorModel() when $default != null:
return $default(_that.success,_that.message,_that.errorCode,_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String? message,  String? errorCode,  Map<String, dynamic>? details)  $default,) {final _that = this;
switch (_that) {
case _ProductErrorModel():
return $default(_that.success,_that.message,_that.errorCode,_that.details);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String? message,  String? errorCode,  Map<String, dynamic>? details)?  $default,) {final _that = this;
switch (_that) {
case _ProductErrorModel() when $default != null:
return $default(_that.success,_that.message,_that.errorCode,_that.details);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductErrorModel extends ProductErrorModel {
  const _ProductErrorModel({this.success = false, this.message, this.errorCode, final  Map<String, dynamic>? details}): _details = details,super._();
  factory _ProductErrorModel.fromJson(Map<String, dynamic> json) => _$ProductErrorModelFromJson(json);

/// Whether the request was successful (always false for errors)
@override@JsonKey() final  bool success;
/// Human-readable error message
@override final  String? message;
/// Machine-readable error code for specific handling
@override final  String? errorCode;
/// Additional error details (field errors, etc.)
 final  Map<String, dynamic>? _details;
/// Additional error details (field errors, etc.)
@override Map<String, dynamic>? get details {
  final value = _details;
  if (value == null) return null;
  if (_details is EqualUnmodifiableMapView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ProductErrorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductErrorModelCopyWith<_ProductErrorModel> get copyWith => __$ProductErrorModelCopyWithImpl<_ProductErrorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductErrorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductErrorModel&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.errorCode, errorCode) || other.errorCode == errorCode)&&const DeepCollectionEquality().equals(other._details, _details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,errorCode,const DeepCollectionEquality().hash(_details));



}

/// @nodoc
abstract mixin class _$ProductErrorModelCopyWith<$Res> implements $ProductErrorModelCopyWith<$Res> {
  factory _$ProductErrorModelCopyWith(_ProductErrorModel value, $Res Function(_ProductErrorModel) _then) = __$ProductErrorModelCopyWithImpl;
@override @useResult
$Res call({
 bool success, String? message, String? errorCode, Map<String, dynamic>? details
});




}
/// @nodoc
class __$ProductErrorModelCopyWithImpl<$Res>
    implements _$ProductErrorModelCopyWith<$Res> {
  __$ProductErrorModelCopyWithImpl(this._self, this._then);

  final _ProductErrorModel _self;
  final $Res Function(_ProductErrorModel) _then;

/// Create a copy of ProductErrorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = freezed,Object? errorCode = freezed,Object? details = freezed,}) {
  return _then(_ProductErrorModel(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,errorCode: freezed == errorCode ? _self.errorCode : errorCode // ignore: cast_nullable_to_non_nullable
as String?,details: freezed == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
