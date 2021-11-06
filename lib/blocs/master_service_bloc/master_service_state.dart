part of 'master_service_bloc.dart';

abstract class MasterServiceState {
  const MasterServiceState();
}

class MasterServiceInitial extends MasterServiceState {}

class GetServiceMasterLoading extends MasterServiceState {}

class ServiceMasterData extends MasterServiceState {
  final List<ServiceModel> listServices;
  final bool hasReachMax;
  ServiceMasterData(this.listServices, this.hasReachMax);
}

class ServiceMasterSuccess extends MasterServiceState {
  final String message;
  ServiceMasterSuccess(this.message);
}

class ServiceMasterError extends MasterServiceState {
  final String message;
  ServiceMasterError(this.message);
}

class CreateMasterServiceLoading extends MasterServiceState {}

class CreateMasterServiceSuccess extends MasterServiceState {
  final String message;
  CreateMasterServiceSuccess(this.message);
}

class CreateMasterServiceError extends MasterServiceState {
  final String message;
  CreateMasterServiceError(this.message);
}

class UpdateMasterServiceLoading extends MasterServiceState {}

class UpdateMasterServiceSuccess extends MasterServiceState {
  final String message;
  UpdateMasterServiceSuccess(this.message);
}

class UpdateMasterServiceError extends MasterServiceState {
  final String message;
  UpdateMasterServiceError(this.message);
}

class DeleteMasterServiceLoading extends MasterServiceState {}

class DeleteMasterServiceSuccess extends MasterServiceState {
  final String message;
  DeleteMasterServiceSuccess(this.message);
}

class DeleteMasterServiceError extends MasterServiceState {
  final String message;
  DeleteMasterServiceError(this.message);
}
