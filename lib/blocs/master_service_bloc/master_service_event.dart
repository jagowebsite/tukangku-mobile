part of 'master_service_bloc.dart';

abstract class MasterServiceEvent {
  const MasterServiceEvent();
}

class GetServiceMaster extends MasterServiceEvent {
  final int limit;
  final bool isInit;
  GetServiceMaster(this.limit, this.isInit);
}

class CreateMasterService extends MasterServiceEvent {
  final ServiceModel serviceModel;
  CreateMasterService(this.serviceModel);
}

class UpdateMasterService extends MasterServiceEvent {
  final ServiceModel serviceModel;
  UpdateMasterService(this.serviceModel);
}

class DeleteMasterService extends MasterServiceEvent {
  final ServiceModel serviceModel;
  DeleteMasterService(this.serviceModel);
}
