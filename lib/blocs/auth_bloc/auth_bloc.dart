import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:equatable/equatable.dart';
import 'package:tukangku/models/login_model.dart';
import 'package:tukangku/models/register_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/user_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository _authRepo = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<LoginProcess>(_loginProcess);
    on<RegisterProcess>(_registerProcess);
    on<GetAuthData>(_authData);
    on<Logout>(_logout);
  }

  Future _loginProcess(LoginProcess event, Emitter<AuthState> emit) async {
    print('Login process...');
    emit(LoginLoading());
    try {
      LoginData? loginData = await _authRepo.login(event.loginModel);
      if (loginData != null) {
        if (loginData.verified!) {
          await _authRepo.setToken(loginData.token!);

          print('Login success');
          emit(LoginSuccess());
        } else {
          print('Please verify your email...');
          emit(VerifyEmail(event.loginModel));
        }
      } else {
        print('Login failed');
        emit(LoginError('Login Error'));
      }
    } catch (e) {
      emit(LoginError('Login Error'));
    }
  }

  Future _registerProcess(
      RegisterProcess event, Emitter<AuthState> emit) async {
    print('Register process...');
    emit(RegisterLoading());
    try {
      ResponseModel? responseModel =
          await _authRepo.register(event.registerModel);
      if (responseModel != null) {
        if (responseModel.status == 'success') {
          emit(RegisterSuccess(responseModel.message!));
        } else {
          emit(RegisterError(responseModel.message!));
        }
      } else {
        print('Register failed');
        emit(RegisterError('Register Error'));
      }
    } catch (e) {
      emit(RegisterError('Register Error'));
    }
  }

  Future _authData(GetAuthData event, Emitter<AuthState> emit) async {
    print('Get auth data...');
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        User? user = await _authRepo.getUser(_token);
        if (user != null) {
          emit(Authorized(user));
        } else {
          emit(UnAuthorized());
        }
      } else {
        emit(UnAuthorized());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future _logout(Logout event, Emitter<AuthState> emit) async {
    print('Logout process...');
    emit(LogoutLoading());
    try {
      String? _token = await _authRepo.hasToken();
      print(_token);
      if (_token != null) {
        ResponseModel? responseModel = await _authRepo.logout(_token);
        if (responseModel != null) {
          responseModel.status == 'success'
              ? emit(LogoutSuccess(responseModel.message!))
              : emit(LogoutError(responseModel.message!));
        } else {
          LogoutError('Terjadi kesalahan, silahkan coba kembali.');
        }
      } else {
        LogoutError('Terjadi kesalahan, silahkan coba kembali.');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
