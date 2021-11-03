import 'package:bloc/bloc.dart';
import 'package:tukangku/models/filter_service_model.dart';
import 'package:tukangku/models/service_model.dart';
import 'package:tukangku/repositories/service_repository.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceRepository _serviceRepo = ServiceRepository();
  FilterServiceModel? filterService;
  List<ServiceModel> listServices = [];
  int page = 1;

  ServiceBloc() : super(ServiceInitial()) {
    on<GetService>(_getService);
  }

  Future _getService(GetService event, Emitter<ServiceState> emit) async {
    try {
      if (event.isInit) {
        print('Get init service ...');
        page = 1;
        emit(GetServiceLoading());
        List<ServiceModel>? data = await _serviceRepo.getServices(
            filterService: filterService, page: page, limit: event.limit);
        if (data != null) {
          listServices = data;
          data.length < event.limit
              ? emit(ServiceData(listServices, true))
              : emit(ServiceData(listServices, false));
        } else {
          emit(ServiceData(listServices, false));
        }
      } else {
        print('Get more service ...');
        page++;
        List<ServiceModel>? data = await _serviceRepo.getServices(
            filterService: filterService, page: page, limit: event.limit);
        if (data != null) {
          listServices.addAll(data);
          data.length < event.limit
              ? emit(ServiceData(listServices, true))
              : emit(ServiceData(listServices, false));
        } else {
          emit(ServiceData(listServices, false));
        }
      }
    } catch (e) {
      emit(ServiceError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }
}
