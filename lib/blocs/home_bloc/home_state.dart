part of 'home_bloc.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {}

class GetServiceHomeLoading extends HomeState {}

class ServiceHomeData extends HomeState {
  final List<ServiceModel> listServices;
  final bool hasReachMax;
  ServiceHomeData(this.listServices, this.hasReachMax);
}

class ServiceHomeSuccess extends HomeState {
  final String message;
  ServiceHomeSuccess(this.message);
}

class ServiceHomeError extends HomeState {
  final String message;
  ServiceHomeError(this.message);
}
