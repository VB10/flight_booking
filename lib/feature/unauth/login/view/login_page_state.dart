import 'package:equatable/equatable.dart';

/// Login page UI state
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
