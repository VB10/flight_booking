import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
final class AuthState extends Equatable {
  const AuthState({
    required this.isLoggedIn,
    this.token,
    this.email,
    this.name,
    this.userId,
  });

  const AuthState.unauthenticated()
      : isLoggedIn = false,
        token = null,
        email = null,
        name = null,
        userId = null;

  final bool isLoggedIn;
  final String? token;
  final String? email;
  final String? name;
  final int? userId;

  AuthState copyWith({
    bool? isLoggedIn,
    String? token,
    String? email,
    String? name,
    int? userId,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      email: email ?? this.email,
      name: name ?? this.name,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [isLoggedIn, token, email, name, userId];
}
