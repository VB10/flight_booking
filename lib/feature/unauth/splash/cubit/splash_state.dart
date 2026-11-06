import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum SplashStatus { checking, updateRequired, ready }

@immutable
final class SplashState extends Equatable {
  const SplashState({
    this.status = SplashStatus.checking,
    this.forceUpdate = false,
    this.updateMessage = '',
    this.isLoggedIn = false,
  });

  final SplashStatus status;
  final bool forceUpdate;

  /// Remote message; empty means "use the localized default".
  final String updateMessage;

  /// Valid only when [status] is [SplashStatus.ready].
  final bool isLoggedIn;

  SplashState copyWith({
    SplashStatus? status,
    bool? forceUpdate,
    String? updateMessage,
    bool? isLoggedIn,
  }) {
    return SplashState(
      status: status ?? this.status,
      forceUpdate: forceUpdate ?? this.forceUpdate,
      updateMessage: updateMessage ?? this.updateMessage,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  @override
  List<Object?> get props => [status, forceUpdate, updateMessage, isLoggedIn];
}
