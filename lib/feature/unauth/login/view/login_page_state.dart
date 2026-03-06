import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Login page UI state
@immutable
final class LoginPageState extends Equatable {
  const LoginPageState({
    this.errorMessage = '',
    this.isLoading = false,
  });

  final String errorMessage;
  final bool isLoading;

  LoginPageState copyWith({
    String? errorMessage,
    bool? isLoading,
  }) {
    return LoginPageState(
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [errorMessage, isLoading];
}
