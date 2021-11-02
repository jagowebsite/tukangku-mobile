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

class UpdatePhotoLoading extends ProfileState {}

class UpdatePhotoSuccess extends ProfileState {
  final String message;
  UpdatePhotoSuccess(this.message);
}

class UpdatePhotoError extends ProfileState {
  final String message;
  UpdatePhotoError(this.message);
}

class ChangePasswordLoading extends ProfileState {}

class ChangePasswordSuccess extends ProfileState {
  final String message;
  ChangePasswordSuccess(this.message);
}

class ChangePasswordError extends ProfileState {
  final String message;
  ChangePasswordError(this.message);
}
