part of 'user_data_bloc.dart';

abstract class UserDataEvent {
  const UserDataEvent();
}

class GetUserData extends UserDataEvent {
  final int limit;
  final bool isInit, isConsumen;
  GetUserData(this.limit, this.isInit, this.isConsumen);
}

class CreateUserData extends UserDataEvent {
  final User user;
  CreateUserData(this.user);
}

class UpdateUserData extends UserDataEvent {
  final User user;
  UpdateUserData(this.user);
}

class DeleteUserData extends UserDataEvent {
  final User user;
  DeleteUserData(this.user);
}
