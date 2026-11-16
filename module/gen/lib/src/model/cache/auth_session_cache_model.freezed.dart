// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_session_cache_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthSessionCacheModel {

 String get token; String get email; String get name; int get userId;
/// Create a copy of AuthSessionCacheModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSessionCacheModelCopyWith<AuthSessionCacheModel> get copyWith => _$AuthSessionCacheModelCopyWithImpl<AuthSessionCacheModel>(this as AuthSessionCacheModel, _$identity);

  /// Serializes this AuthSessionCacheModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSessionCacheModel&&(identical(other.token, token) || other.token == token)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,email,name,userId);

@override
String toString() {
  return 'AuthSessionCacheModel(token: $token, email: $email, name: $name, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $AuthSessionCacheModelCopyWith<$Res>  {
  factory $AuthSessionCacheModelCopyWith(AuthSessionCacheModel value, $Res Function(AuthSessionCacheModel) _then) = _$AuthSessionCacheModelCopyWithImpl;
@useResult
$Res call({
 String token, String email, String name, int userId
});




}
/// @nodoc
class _$AuthSessionCacheModelCopyWithImpl<$Res>
    implements $AuthSessionCacheModelCopyWith<$Res> {
  _$AuthSessionCacheModelCopyWithImpl(this._self, this._then);

  final AuthSessionCacheModel _self;
  final $Res Function(AuthSessionCacheModel) _then;

/// Create a copy of AuthSessionCacheModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? email = null,Object? name = null,Object? userId = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthSessionCacheModel].
extension AuthSessionCacheModelPatterns on AuthSessionCacheModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthSessionCacheModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthSessionCacheModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthSessionCacheModel value)  $default,){
final _that = this;
switch (_that) {
case _AuthSessionCacheModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthSessionCacheModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuthSessionCacheModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String email,  String name,  int userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthSessionCacheModel() when $default != null:
return $default(_that.token,_that.email,_that.name,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String email,  String name,  int userId)  $default,) {final _that = this;
switch (_that) {
case _AuthSessionCacheModel():
return $default(_that.token,_that.email,_that.name,_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String email,  String name,  int userId)?  $default,) {final _that = this;
switch (_that) {
case _AuthSessionCacheModel() when $default != null:
return $default(_that.token,_that.email,_that.name,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthSessionCacheModel implements AuthSessionCacheModel {
  const _AuthSessionCacheModel({required this.token, required this.email, required this.name, required this.userId});
  factory _AuthSessionCacheModel.fromJson(Map<String, dynamic> json) => _$AuthSessionCacheModelFromJson(json);

@override final  String token;
@override final  String email;
@override final  String name;
@override final  int userId;

/// Create a copy of AuthSessionCacheModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthSessionCacheModelCopyWith<_AuthSessionCacheModel> get copyWith => __$AuthSessionCacheModelCopyWithImpl<_AuthSessionCacheModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthSessionCacheModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthSessionCacheModel&&(identical(other.token, token) || other.token == token)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,email,name,userId);

@override
String toString() {
  return 'AuthSessionCacheModel(token: $token, email: $email, name: $name, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$AuthSessionCacheModelCopyWith<$Res> implements $AuthSessionCacheModelCopyWith<$Res> {
  factory _$AuthSessionCacheModelCopyWith(_AuthSessionCacheModel value, $Res Function(_AuthSessionCacheModel) _then) = __$AuthSessionCacheModelCopyWithImpl;
@override @useResult
$Res call({
 String token, String email, String name, int userId
});




}
/// @nodoc
class __$AuthSessionCacheModelCopyWithImpl<$Res>
    implements _$AuthSessionCacheModelCopyWith<$Res> {
  __$AuthSessionCacheModelCopyWithImpl(this._self, this._then);

  final _AuthSessionCacheModel _self;
  final $Res Function(_AuthSessionCacheModel) _then;

/// Create a copy of AuthSessionCacheModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? email = null,Object? name = null,Object? userId = null,}) {
  return _then(_AuthSessionCacheModel(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
