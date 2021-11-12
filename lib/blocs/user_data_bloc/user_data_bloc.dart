import 'package:bloc/bloc.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/user_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/user_data_repository.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  AuthRepository _authRepo = AuthRepository();
  UserDataRepository _userDataRepo = UserDataRepository();
  List<User> listUsers = [];
  int page = 1;

  UserDataBloc() : super(UserDataInitial()) {
    on<GetUserData>(_getUserData);
    on<CreateUserData>(_createUserData);
    on<UpdateUserData>(_updateUserData);
    on<DeleteUserData>(_deleteUserData);
  }

  Future _getUserData(GetUserData event, Emitter<UserDataState> emit) async {
    try {
      String? _token = await _authRepo.hasToken();
      if (event.isInit) {
        print('Get init Banner ...');
        page = 1;
        emit(GetUserDataLoading());
        List<User>? data = await _userDataRepo.getUserData(_token!,
            page: page, limit: event.limit, isConsumen: event.isConsumen);
        if (data != null) {
          listUsers = data;
          data.length < event.limit
              ? emit(UserData(listUsers, true))
              : emit(UserData(listUsers, false));
        } else {
          emit(UserData(listUsers, false));
        }
      } else {
        print('Get more banner ...');
        page++;
        List<User>? data = await _userDataRepo.getUserData(_token!,
            page: page, limit: event.limit, isConsumen: event.isConsumen);
        if (data != null) {
          listUsers.addAll(data);
          data.length < event.limit
              ? emit(UserData(listUsers, true))
              : emit(UserData(listUsers, false));
        } else {
          emit(UserData(listUsers, false));
        }
      }
    } catch (e) {
      emit(UserDataError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _createUserData(
      CreateUserData event, Emitter<UserDataState> emit) async {
    emit(CreateUserDataLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _userDataRepo.createUserData(_token, event.user);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(CreateUserDataSuccess(responseModel.message ?? ''));
          } else {
            emit(CreateUserDataError(responseModel.message ?? ''));
          }
        } else {
          emit(CreateUserDataError('Tambah user gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(CreateUserDataError('Tambah user gagal, silahkan coba kembali'));
    }
  }

  Future _updateUserData(
      UpdateUserData event, Emitter<UserDataState> emit) async {
    emit(UpdateUserDataLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _userDataRepo.updateUserData(_token, event.user);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(UpdateUserDataSuccess(responseModel.message ?? ''));
          } else {
            emit(UpdateUserDataError(responseModel.message ?? ''));
          }
        } else {
          emit(UpdateUserDataError('Update user gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(UpdateUserDataError('Update user gagal, silahkan coba kembali'));
    }
  }

  Future _deleteUserData(
      DeleteUserData event, Emitter<UserDataState> emit) async {
    emit(DeleteUserDataLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _userDataRepo.deleteUserData(_token, event.user.id!);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(DeleteUserDataSuccess(responseModel.message ?? ''));
          } else {
            emit(DeleteUserDataError(responseModel.message ?? ''));
          }
        } else {
          emit(DeleteUserDataError('Delete user gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(DeleteUserDataError('Delete user gagal, silahkan coba kembali'));
    }
  }
}
