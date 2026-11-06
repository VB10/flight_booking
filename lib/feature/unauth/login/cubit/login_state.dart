import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
final class LoginState extends Equatable {
  const LoginState({
    this.isLoading = false,
    this.errorMessage = '',
    this.emailError = '',
    this.passwordError = '',
    this.isSuccess = false,
  });

  final bool isLoading;

  /// Server / network failure shown through a snackbar.
  final String errorMessage;

  /// Client-side validation errors shown under the fields.
  final String emailError;
  final String passwordError;
  final bool isSuccess;

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? emailError,
    String? passwordError,
    bool? isSuccess,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    emailError,
    passwordError,
    isSuccess,
  ];
}
