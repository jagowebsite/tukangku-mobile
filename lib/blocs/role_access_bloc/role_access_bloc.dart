import 'package:bloc/bloc.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/role_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/role_repository.dart';

part 'role_access_event.dart';
part 'role_access_state.dart';

class RoleAccessBloc extends Bloc<RoleAccessEvent, RoleAccessState> {
  RoleRepository _roleRepo = RoleRepository();
  AuthRepository _authRepo = AuthRepository();
  List<RoleAccessModel> listRoleAccess = [];
  int page = 1;

  RoleAccessBloc() : super(RoleAccessInitial()) {
    on<GetRoleAccess>(_getRoleAccess);
    on<CreateRoleAccess>(_createRoleAccess);
    on<UpdateRoleAccess>(_updateRoleAccess);
    on<DeleteRoleAccess>(_deleteRoleAccess);
  }

  Future _getRoleAccess(
      GetRoleAccess event, Emitter<RoleAccessState> emit) async {
    try {
      String? _token = await _authRepo.hasToken();
      if (event.isInit) {
        print('Get init role access ...');
        page = 1;
        emit(GetRoleAccessLoading());
        List<RoleAccessModel>? data = await _roleRepo.getRoleAccess(_token!,
            page: page, limit: event.limit);
        if (data != null) {
          listRoleAccess = data;
          data.length < event.limit
              ? emit(RoleAccessData(listRoleAccess, true))
              : emit(RoleAccessData(listRoleAccess, false));
        } else {
          emit(RoleAccessData(listRoleAccess, false));
        }
      } else {
        print('Get more role access ...');
        page++;
        List<RoleAccessModel>? data = await _roleRepo.getRoleAccess(_token!,
            page: page, limit: event.limit);
        if (data != null) {
          listRoleAccess.addAll(data);
          data.length < event.limit
              ? emit(RoleAccessData(listRoleAccess, true))
              : emit(RoleAccessData(listRoleAccess, false));
        } else {
          emit(RoleAccessData(listRoleAccess, false));
        }
      }
    } catch (e) {
      emit(RoleAccessError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _createRoleAccess(
      CreateRoleAccess event, Emitter<RoleAccessState> emit) async {
    emit(CreateRoleAccessLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _roleRepo.createRoleAccess(_token, event.roleAccessModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(CreateRoleAccessSuccess(responseModel.message ?? ''));
          } else {
            emit(CreateRoleAccessError(responseModel.message ?? ''));
          }
        } else {
          emit(CreateRoleAccessError(
              'Tambah role akses gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(CreateRoleAccessError(
          'Tambah role akses gagal, silahkan coba kembali'));
    }
  }

  Future _updateRoleAccess(
      UpdateRoleAccess event, Emitter<RoleAccessState> emit) async {
    emit(UpdateRoleAccessLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _roleRepo.updateRoleAccess(_token, event.roleAccessModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(UpdateRoleAccessSuccess(responseModel.message ?? ''));
          } else {
            emit(UpdateRoleAccessError(responseModel.message ?? ''));
          }
        } else {
          emit(UpdateRoleAccessError(
              'Update role Access gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(UpdateRoleAccessError(
          'Update role Access gagal, silahkan coba kembali'));
    }
  }

  Future _deleteRoleAccess(
      DeleteRoleAccess event, Emitter<RoleAccessState> emit) async {
    emit(DeleteRoleAccessLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _roleRepo.deleteRoleAccess(_token, event.roleAccessModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(DeleteRoleAccessSuccess(responseModel.message ?? ''));
          } else {
            emit(DeleteRoleAccessError(responseModel.message ?? ''));
          }
        } else {
          emit(DeleteRoleAccessError(
              'Delete role access gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(DeleteRoleAccessError(
          'Delete role access gagal, silahkan coba kembali'));
    }
  }
}
