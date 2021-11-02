import 'package:bloc/bloc.dart';
import 'package:tukangku/models/service_model.dart';
import 'package:tukangku/repositories/service_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

enum ServiceHomeStatus { initial, getMore }

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  ServiceRepository _serviceRepo = ServiceRepository();
  List<ServiceModel> listServices = [];
  int page = 1;

  ServiceHomeStatus serviceHomeStatus = ServiceHomeStatus.initial;

  HomeBloc() : super(HomeInitial()) {
    on<GetServiceHome>(_getServiceHome);
  }

  Future _getServiceHome(GetServiceHome event, Emitter<HomeState> emit) async {
    try {
      if (event.isInit) {
        print('Get init service...');
        page = 1;
        emit(GetServiceHomeLoading());
        List<ServiceModel>? data =
            await _serviceRepo.getServices(page: page, limit: event.limit);
        if (data != null) {
          listServices = data;
          data.length < event.limit
              ? emit(ServiceHomeData(listServices, true))
              : emit(ServiceHomeData(listServices, false));
        } else {
          emit(ServiceHomeData(listServices, false));
        }
      } else {
        print('Get more service...');
        page++;
        List<ServiceModel>? data =
            await _serviceRepo.getServices(page: page, limit: event.limit);
        if (data != null) {
          listServices.addAll(data);
          data.length < event.limit
              ? emit(ServiceHomeData(listServices, true))
              : emit(ServiceHomeData(listServices, false));
        } else {
          emit(ServiceHomeData(listServices, false));
        }
      }
    } catch (e) {
      emit(ServiceHomeError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }
}
