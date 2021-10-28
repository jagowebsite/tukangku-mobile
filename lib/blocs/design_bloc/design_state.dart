part of 'design_bloc.dart';

abstract class DesignState {}

class DesignInitial extends DesignState {}

class GetServiceDesignLoading extends DesignState {}

class ServiceDesignData extends DesignState {
  final List<ServiceModel> listServices;
  final bool hasReachMax;
  ServiceDesignData(this.listServices, this.hasReachMax);
}

class ServiceDesignSuccess extends DesignState {
  final String message;
  ServiceDesignSuccess(this.message);
}

class ServiceDesignError extends DesignState {
  final String message;
  ServiceDesignError(this.message);
}
