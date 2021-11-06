import 'package:bloc/bloc.dart';
import 'package:tukangku/models/filter_service_model.dart';
import 'package:tukangku/models/service_model.dart';
import 'package:tukangku/repositories/master_service_repository.dart';

part 'master_service_event.dart';
part 'master_service_state.dart';

class MasterServiceBloc extends Bloc<MasterServiceEvent, MasterServiceState> {
  MasterServiceRepository _masterServiceRepo = MasterServiceRepository();
  FilterServiceModel? filterService;
  List<ServiceModel> listServiceMaster = [];
  int page = 1;

  MasterServiceBloc() : super(MasterServiceInitial()) {
    on<GetServiceMaster>(_getServiceMaster);
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
}
