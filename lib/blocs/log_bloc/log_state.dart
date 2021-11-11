part of 'log_bloc.dart';

abstract class LogState {
  const LogState();
}

class LogInitial extends LogState {}

class GetUserLogLoading extends LogState {}

class UserLogData extends LogState {
  final List<UserLogModel> listUserLogs;
  final bool hasReachMax;
  UserLogData(this.listUserLogs, this.hasReachMax);
}

class UserLogSuccess extends LogState {
  final String message;
  UserLogSuccess(this.message);
}

class UserLogError extends LogState {
  final String message;
  UserLogError(this.message);
}

class GetGPSLogLoading extends LogState {}

class GPSLogData extends LogState {
  final List<GPSLogModel> listGPSLogs;
  final bool hasReachMax;
  GPSLogData(this.listGPSLogs, this.hasReachMax);
}

class GPSLogSuccess extends LogState {
  final String message;
  GPSLogSuccess(this.message);
}

class GPSLogError extends LogState {
  final String message;
  GPSLogError(this.message);
}
