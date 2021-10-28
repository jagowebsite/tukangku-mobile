import 'package:bloc/bloc.dart';
import 'package:tukangku/models/service_model.dart';
import 'package:tukangku/repositories/service_repository.dart';

part 'design_event.dart';
part 'design_state.dart';

enum ServiceDesignStatus { initial, getMore }

class DesignBloc extends Bloc<DesignEvent, DesignState> {
  ServiceRepository _serviceRepo = ServiceRepository();
  List<ServiceModel> listServices = [];
  int page = 1;

  ServiceDesignStatus serviceHomeStatus = ServiceDesignStatus.initial;

  DesignBloc() : super(DesignInitial()) {
    on<GetServiceDesign>(_getServiceDesign);
  }

  Future _getServiceDesign(
      GetServiceDesign event, Emitter<DesignState> emit) async {
    try {
      if (event.isInit) {
        print('Get init service design...');
        page = 1;
        emit(GetServiceDesignLoading());
        List<ServiceModel>? data =
            await _serviceRepo.getServices(page: page, limit: event.limit);
        if (data != null) {
          listServices = data;
          data.length < event.limit
              ? emit(ServiceDesignData(listServices, true))
              : emit(ServiceDesignData(listServices, false));
        } else {
          emit(ServiceDesignData(listServices, false));
        }
      } else {
        print('Get more service design...');
        page++;
        List<ServiceModel>? data =
            await _serviceRepo.getServices(page: page, limit: event.limit);
        if (data != null) {
          listServices.addAll(data);
          data.length < event.limit
              ? emit(ServiceDesignData(listServices, true))
              : emit(ServiceDesignData(listServices, false));
        } else {
          emit(ServiceDesignData(listServices, false));
        }
      }
    } catch (e) {
      emit(ServiceDesignError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }
}
