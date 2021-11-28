part of 'report_bloc.dart';

abstract class ReportEvent {
  const ReportEvent();
}

class GetReportService extends ReportEvent {
  final int limit;
  final bool isInit;
  GetReportService(this.limit, this.isInit);
}

class GetReportAll extends ReportEvent {
  final int limit;
  final bool isInit;
  GetReportAll(this.limit, this.isInit);
}
