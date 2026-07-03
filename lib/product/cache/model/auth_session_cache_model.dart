import 'package:cache_manager/cache_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_session_cache_model.g.dart';

/// Persistence model (DTO) for the auth session.
///
/// Pure Dart — Equatable + immutable + JSON, with NO Hive dependency. It
/// implements [CacheModel] so `ICacheManager.writeModel` can store it as JSON;
/// Hive stays entirely inside the `cache_manager` package. This keeps the app's
/// domain/state (e.g. AuthState) decoupled from the storage backend.
@JsonSerializable()
final class AuthSessionCacheModel extends Equatable implements CacheModel {
  const AuthSessionCacheModel({
    required this.token,
    required this.email,
    required this.name,
    required this.userId,
  });

  factory AuthSessionCacheModel.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionCacheModelFromJson(json);

  final String token;
  final String email;
  final String name;
  final int userId;

  @override
  Map<String, dynamic> toJson() => _$AuthSessionCacheModelToJson(this);

  @override
  List<Object?> get props => [token, email, name, userId];
}
