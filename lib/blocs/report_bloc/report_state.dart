part of 'report_bloc.dart';

abstract class ReportState {
  const ReportState();
}

class ReportInitial extends ReportState {}

class GetReportServiceLoading extends ReportState {}

class ReportServiceData extends ReportState {
  final List<ReportModel> listReports;
  final bool hasReachMax;
  ReportServiceData(this.listReports, this.hasReachMax);
}

class ReportServiceSuccess extends ReportState {
  final String message;
  ReportServiceSuccess(this.message);
}

class ReportServiceError extends ReportState {
  final String message;
  ReportServiceError(this.message);
}

class GetReportAllLoading extends ReportState {}

class ReportAllData extends ReportState {
  final List<ReportModel> listReports;
  final bool hasReachMax;
  ReportAllData(this.listReports, this.hasReachMax);
}

class ReportAllSuccess extends ReportState {
  final String message;
  ReportAllSuccess(this.message);
}

class ReportAllError extends ReportState {
  final String message;
  ReportAllError(this.message);
}
