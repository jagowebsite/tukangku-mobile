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

class RegisterProcess extends AuthEvent {
  final RegisterModel registerModel;

  RegisterProcess(this.registerModel);

  @override
  List<Object> get props => [registerModel];
}

// class ForgotPassword extends AuthEvent {
//   final String email;

//   ForgotPassword(this.email);

//   @override
//   List<Object> get props => [email];
// }

class GetAuthData extends AuthEvent {}

class Logout extends AuthEvent {}
