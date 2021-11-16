part of 'user_data_bloc.dart';

abstract class UserDataState {
  const UserDataState();
}

class UserDataInitial extends UserDataState {}

class GetUserDataLoading extends UserDataState {}

class UserData extends UserDataState {
  final List<User> listUsers;
  final bool hasReachMax;
  UserData(this.listUsers, this.hasReachMax);
}

class UserDataSuccess extends UserDataState {
  final String message;
  UserDataSuccess(this.message);
}

class UserDataError extends UserDataState {
  final String message;
  UserDataError(this.message);
}

class CreateUserDataLoading extends UserDataState {}

class CreateUserDataSuccess extends UserDataState {
  final String message;
  CreateUserDataSuccess(this.message);
}

class CreateUserDataError extends UserDataState {
  final String message;
  CreateUserDataError(this.message);
}

class UpdateUserDataLoading extends UserDataState {}

class UpdateUserDataSuccess extends UserDataState {
  final String message;
  UpdateUserDataSuccess(this.message);
}

class UpdateUserDataError extends UserDataState {
  final String message;
  UpdateUserDataError(this.message);
}

class DeleteUserDataLoading extends UserDataState {}

class DeleteUserDataSuccess extends UserDataState {
  final String message;
  DeleteUserDataSuccess(this.message);
}

class DeleteUserDataError extends UserDataState {
  final String message;
  DeleteUserDataError(this.message);
}

class ChangePasswordUserDataLoading extends UserDataState {}

class ChangePasswordUserDataSuccess extends UserDataState {
  final String message;
  ChangePasswordUserDataSuccess(this.message);
}

class ChangePasswordUserDataError extends UserDataState {
  final String message;
  ChangePasswordUserDataError(this.message);
}
