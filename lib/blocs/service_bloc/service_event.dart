part of 'service_bloc.dart';

abstract class ServiceEvent {
  const ServiceEvent();
}

class GetService extends ServiceEvent {
  final int limit;
  final bool isInit;
  GetService(this.limit, this.isInit);
}
