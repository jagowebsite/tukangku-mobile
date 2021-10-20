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

class LoginError extends AuthState {}

class LoginSuccess extends AuthState {}

// Register

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {}

// Logout

class LogoutLoading extends AuthState {}

class LogoutError extends AuthState {}

class LogoutSuccess extends AuthState {}

// Authenticate

class AuthLoading extends AuthState {}

class Authorized extends AuthState {}

class UnAuthorized extends AuthState {}

class AuthError extends AuthState {}
