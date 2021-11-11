part of 'log_bloc.dart';

abstract class LogEvent {
  const LogEvent();
}

class GetUserLog extends LogEvent {
  final int limit;
  final bool isInit;
  GetUserLog(this.limit, this.isInit);
}

class GetGPSLog extends LogEvent {
  final int limit;
  final bool isInit;
  GetGPSLog(this.limit, this.isInit);
}
