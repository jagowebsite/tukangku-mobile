part of 'profile_bloc.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class UpdateProfileLoading extends ProfileState {}

class UpdateProfileSuccess extends ProfileState {
  final String message;
  UpdateProfileSuccess(this.message);
}

class UpdateProfileError extends ProfileState {
  final String message;
  UpdateProfileError(this.message);
}
