part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginProcess extends AuthEvent {
  final LoginModel loginModel;

  LoginProcess(this.loginModel);

  @override
  List<Object> get props => [loginModel];
}

class GetAuthData extends AuthEvent {}

class OnLogout extends AuthEvent {}
