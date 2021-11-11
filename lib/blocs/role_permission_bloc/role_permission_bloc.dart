import 'package:bloc/bloc.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/role_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/role_repository.dart';

part 'role_permission_event.dart';
part 'role_permission_state.dart';

class RolePermissionBloc
    extends Bloc<RolePermissionEvent, RolePermissionState> {
  AuthRepository _authRepo = AuthRepository();
  RoleRepository _roleRepo = RoleRepository();
  List<RolePermissionModel> listRolePermissions = [];
  int page = 1;

  RolePermissionBloc() : super(RolePermissionInitial()) {
    on<GetRolePermission>(_getRolePermission);
    on<CreateRolePermission>(_createRolePermission);
    on<UpdateRolePermission>(_updateRolePermission);
    on<DeleteRolePermission>(_deleteRolePermission);
  }

  Future _getRolePermission(
      GetRolePermission event, Emitter<RolePermissionState> emit) async {
    try {
      String? _token = await _authRepo.hasToken();
      if (event.isInit) {
        print('Get init Banner ...');
        page = 1;
        emit(GetRolePermissionLoading());
        List<RolePermissionModel>? data = await _roleRepo
            .getRolePermission(_token!, page: page, limit: event.limit);
        if (data != null) {
          listRolePermissions = data;
          data.length < event.limit
              ? emit(RolePermissionData(listRolePermissions, true))
              : emit(RolePermissionData(listRolePermissions, false));
        } else {
          emit(RolePermissionData(listRolePermissions, false));
        }
      } else {
        print('Get more banner ...');
        page++;
        List<RolePermissionModel>? data = await _roleRepo
            .getRolePermission(_token!, page: page, limit: event.limit);
        if (data != null) {
          listRolePermissions.addAll(data);
          data.length < event.limit
              ? emit(RolePermissionData(listRolePermissions, true))
              : emit(RolePermissionData(listRolePermissions, false));
        } else {
          emit(RolePermissionData(listRolePermissions, false));
        }
      }
    } catch (e) {
      emit(RolePermissionError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _createRolePermission(
      CreateRolePermission event, Emitter<RolePermissionState> emit) async {
    emit(CreateRolePermissionLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel = await _roleRepo.createRolePermission(
            _token, event.rolePermissionModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(CreateRolePermissionSuccess(responseModel.message ?? ''));
          } else {
            emit(CreateRolePermissionError(responseModel.message ?? ''));
          }
        } else {
          emit(CreateRolePermissionError(
              'Tambah role permission gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(CreateRolePermissionError(
          'Tambah role permission gagal, silahkan coba kembali'));
    }
  }

  Future _updateRolePermission(
      UpdateRolePermission event, Emitter<RolePermissionState> emit) async {
    emit(UpdateRolePermissionLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel = await _roleRepo.updateRolePermission(
            _token, event.rolePermissionModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(UpdateRolePermissionSuccess(responseModel.message ?? ''));
          } else {
            emit(UpdateRolePermissionError(responseModel.message ?? ''));
          }
        } else {
          emit(UpdateRolePermissionError(
              'Update banner gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(UpdateRolePermissionError(
          'Update banner gagal, silahkan coba kembali'));
    }
  }

  Future _deleteRolePermission(
      DeleteRolePermission event, Emitter<RolePermissionState> emit) async {
    emit(DeleteRolePermissionLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel = await _roleRepo.deleteRolePermission(
            _token, event.rolePermissionModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(DeleteRolePermissionSuccess(responseModel.message ?? ''));
          } else {
            emit(DeleteRolePermissionError(responseModel.message ?? ''));
          }
        } else {
          emit(DeleteRolePermissionError(
              'Delete banner gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(DeleteRolePermissionError(
          'Delete banner gagal, silahkan coba kembali'));
    }
  }
}
