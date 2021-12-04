part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

// Login

class LoginLoading extends AuthState {}

class LoginError extends AuthState {
  final String message;

  LoginError(this.message);

  @override
  List<Object> get props => [message];
}

class LoginSuccess extends AuthState {}

// Register

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final String message;
  RegisterSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class RegisterError extends AuthState {
  final String message;
  RegisterError(this.message);

  @override
  List<Object> get props => [message];
}

// Logout

class LogoutLoading extends AuthState {}

class LogoutError extends AuthState {
  final String message;
  LogoutError(this.message);

  @override
  List<Object> get props => [message];
}

class LogoutSuccess extends AuthState {
  final String message;
  LogoutSuccess(this.message);

  @override
  List<Object> get props => [message];
}

// Authenticate

class AuthLoading extends AuthState {}

class Authorized extends AuthState {
  final User user;

  Authorized(this.user);

  @override
  List<Object> get props => [user];
}

class UnAuthorized extends AuthState {}

class AuthError extends AuthState {}

// Verify Email

class VerifyEmail extends AuthState {
  final LoginModel loginModel;

  VerifyEmail(this.loginModel);
}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {
  final String message;
  ForgotPasswordSuccess(this.message);
}

class ForgotPasswordError extends AuthState {
  final String message;
  ForgotPasswordError(this.message);
}
