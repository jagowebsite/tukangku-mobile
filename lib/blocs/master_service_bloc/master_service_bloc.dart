import 'package:bloc/bloc.dart';
import 'package:tukangku/models/filter_service_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/models/service_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/master_service_repository.dart';

part 'master_service_event.dart';
part 'master_service_state.dart';

class MasterServiceBloc extends Bloc<ServiceMasterEvent, MasterServiceState> {
  AuthRepository _authRepo = AuthRepository();
  MasterServiceRepository _masterServiceRepo = MasterServiceRepository();
  FilterServiceModel? filterService;
  List<ServiceModel> listServiceMaster = [];
  int page = 1;

  MasterServiceBloc() : super(MasterServiceInitial()) {
    on<GetServiceMaster>(_getServiceMaster);
    on<CreateServiceMaster>(_createMasterService);
    on<UpdateServiceMaster>(_updateMasterService);
    on<DeleteServiceMaster>(_deleteMasterService);
  }

  Future _getServiceMaster(
      GetServiceMaster event, Emitter<MasterServiceState> emit) async {
    try {
      if (event.isInit) {
        print('Get init service ...');
        page = 1;
        emit(GetServiceMasterLoading());
        List<ServiceModel>? data = await _masterServiceRepo.getServiceMaster(
            filterService: filterService, page: page, limit: event.limit);
        if (data != null) {
          listServiceMaster = data;
          data.length < event.limit
              ? emit(ServiceMasterData(listServiceMaster, true))
              : emit(ServiceMasterData(listServiceMaster, false));
        } else {
          emit(ServiceMasterData(listServiceMaster, false));
        }
      } else {
        print('Get more service ...');
        page++;
        List<ServiceModel>? data = await _masterServiceRepo.getServiceMaster(
            filterService: filterService, page: page, limit: event.limit);
        if (data != null) {
          listServiceMaster.addAll(data);
          data.length < event.limit
              ? emit(ServiceMasterData(listServiceMaster, true))
              : emit(ServiceMasterData(listServiceMaster, false));
        } else {
          emit(ServiceMasterData(listServiceMaster, false));
        }
      }
    } catch (e) {
      emit(ServiceMasterError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _createMasterService(
      CreateServiceMaster event, Emitter<MasterServiceState> emit) async {
    emit(CreateMasterServiceLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel = await _masterServiceRepo
            .createMasterService(_token, event.serviceModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(CreateMasterServiceSuccess(responseModel.message ?? ''));
          } else {
            emit(CreateMasterServiceError(responseModel.message ?? ''));
          }
        } else {
          emit(CreateMasterServiceError(
              'Tambah service gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(CreateMasterServiceError(
          'Tambah service gagal, silahkan coba kembali'));
    }
  }

  Future _updateMasterService(
      UpdateServiceMaster event, Emitter<MasterServiceState> emit) async {
    emit(UpdateMasterServiceLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel = await _masterServiceRepo
            .updateMasterService(_token, event.serviceModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(UpdateMasterServiceSuccess(responseModel.message ?? ''));
          } else {
            emit(UpdateMasterServiceError(responseModel.message ?? ''));
          }
        } else {
          emit(UpdateMasterServiceError(
              'Update service gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(UpdateMasterServiceError(
          'Update service gagal, silahkan coba kembali'));
    }
  }

  Future _deleteMasterService(
      DeleteServiceMaster event, Emitter<MasterServiceState> emit) async {
    emit(DeleteMasterServiceLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel = await _masterServiceRepo
            .deleteMasterService(_token, event.serviceModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(DeleteMasterServiceSuccess(responseModel.message ?? ''));
          } else {
            emit(DeleteMasterServiceError(responseModel.message ?? ''));
          }
        } else {
          emit(DeleteMasterServiceError(
              'Delete service gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(DeleteMasterServiceError(
          'Delete service gagal, silahkan coba kembali'));
    }
  }
}
