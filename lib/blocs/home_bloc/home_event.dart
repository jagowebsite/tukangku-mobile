part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class GetServiceHome extends HomeEvent {
  final int limit;
  final bool isInit;
  GetServiceHome(this.limit, this.isInit);
}
