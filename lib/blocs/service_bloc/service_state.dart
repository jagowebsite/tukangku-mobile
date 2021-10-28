part of 'service_bloc.dart';

abstract class ServiceState {
  const ServiceState();
}

class ServiceInitial extends ServiceState {}

class GetServiceLoading extends ServiceState {}

class ServiceData extends ServiceState {
  final List<ServiceModel> listServices;
  final bool hasReachMax;
  ServiceData(this.listServices, this.hasReachMax);
}

class ServiceSuccess extends ServiceState {
  final String message;
  ServiceSuccess(this.message);
}

class ServiceError extends ServiceState {
  final String message;
  ServiceError(this.message);
}
