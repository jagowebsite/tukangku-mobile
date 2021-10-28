part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetServiceHome extends HomeEvent {
  final int limit;
  final bool isInit;
  GetServiceHome(this.limit, this.isInit);

  @override
  List<Object> get props => [limit, isInit];
}
