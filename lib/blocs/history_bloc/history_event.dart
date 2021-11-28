part of 'history_bloc.dart';

abstract class HistoryEvent {
  const HistoryEvent();
}

class GetHistoryEmployee extends HistoryEvent {
  final int limit;
  final bool isInit;
  GetHistoryEmployee(this.limit, this.isInit);
}

class GetHistoryConsumen extends HistoryEvent {
  final int limit;
  final bool isInit;
  GetHistoryConsumen(this.limit, this.isInit);
}
