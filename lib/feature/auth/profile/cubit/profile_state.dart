import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gen/gen.dart';

enum ProfileStatus { loading, success, failure }

@immutable
final class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.loading,
    this.profile,
  });

  final ProfileStatus status;
  final ProfileData? profile;

  ProfileState copyWith({ProfileStatus? status, ProfileData? profile}) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [status, profile];
}
