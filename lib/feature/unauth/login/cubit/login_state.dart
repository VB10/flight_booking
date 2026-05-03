import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
final class LoginState extends Equatable {
  const LoginState({
    this.isLoading = false,
    this.errorMessage = '',
    this.isSuccess = false,
  });

  final bool isLoading;
  final String errorMessage;
  final bool isSuccess;

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, isSuccess];
}
