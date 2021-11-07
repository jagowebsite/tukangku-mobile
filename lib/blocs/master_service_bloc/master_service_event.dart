part of 'master_service_bloc.dart';

abstract class ServiceMasterEvent {
  const ServiceMasterEvent();
}

class GetServiceMaster extends ServiceMasterEvent {
  final int limit;
  final bool isInit;
  GetServiceMaster(this.limit, this.isInit);
}

class CreateServiceMaster extends ServiceMasterEvent {
  final ServiceModel serviceModel;
  CreateServiceMaster(this.serviceModel);
}

class UpdateServiceMaster extends ServiceMasterEvent {
  final ServiceModel serviceModel;
  UpdateServiceMaster(this.serviceModel);
}

class DeleteServiceMaster extends ServiceMasterEvent {
  final ServiceModel serviceModel;
  DeleteServiceMaster(this.serviceModel);
}
