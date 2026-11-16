import 'package:cache_manager/cache_manager.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session_cache_model.freezed.dart';
part 'auth_session_cache_model.g.dart';

/// Persistence model (DTO) for the auth session.
///
/// Pure Dart — freezed (immutable + value equality) + JSON, with NO Hive
/// dependency. It implements [CacheModel] so `ICacheManager.writeModel` can
/// store it as JSON; Hive stays entirely inside the `cache_manager` package.
/// This keeps the app's domain/state (e.g. AuthState) decoupled from the
/// storage backend.
@freezed
abstract class AuthSessionCacheModel
    with _$AuthSessionCacheModel
    implements CacheModel {
  const factory AuthSessionCacheModel({
    required String token,
    required String email,
    required String name,
    required int userId,
  }) = _AuthSessionCacheModel;

  factory AuthSessionCacheModel.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionCacheModelFromJson(json);
}
