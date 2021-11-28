import 'package:bloc/bloc.dart';
import 'package:tukangku/models/report_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/report_repository.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  AuthRepository _authRepo = AuthRepository();
  ReportRepository _reportRepo = ReportRepository();
  List<ReportModel> listReports = [];
  int page = 1;

  ReportBloc() : super(ReportInitial()) {
    on<GetReportService>(_getReportService);
    on<GetReportAll>(_getReportAll);
  }
  Future _getReportService(
      GetReportService event, Emitter<ReportState> emit) async {
    try {
      String? _token = await _authRepo.hasToken();
      if (event.isInit) {
        print('Get init report service ...');
        page = 1;
        emit(GetReportServiceLoading());
        List<ReportModel>? data = await _reportRepo.getReportService(_token!,
            page: page, limit: event.limit);
        if (data != null) {
          listReports = data;
          data.length < event.limit
              ? emit(ReportServiceData(listReports, true))
              : emit(ReportServiceData(listReports, false));
        } else {
          emit(ReportServiceData(listReports, false));
        }
      } else {
        print('Get more report service ...');
        page++;
        List<ReportModel>? data = await _reportRepo.getReportService(_token!,
            page: page, limit: event.limit);
        if (data != null) {
          listReports.addAll(data);
          data.length < event.limit
              ? emit(ReportServiceData(listReports, true))
              : emit(ReportServiceData(listReports, false));
        } else {
          emit(ReportServiceData(listReports, false));
        }
      }
    } catch (e) {
      emit(ReportServiceError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _getReportAll(GetReportAll event, Emitter<ReportState> emit) async {
    try {
      String? _token = await _authRepo.hasToken();
      if (event.isInit) {
        print('Get init report all ...');
        page = 1;
        emit(GetReportAllLoading());
        List<ReportModel>? data = await _reportRepo.getReportAll(_token!,
            page: page, limit: event.limit);
        if (data != null) {
          listReports = data;
          data.length < event.limit
              ? emit(ReportAllData(listReports, true))
              : emit(ReportAllData(listReports, false));
        } else {
          emit(ReportAllData(listReports, false));
        }
      } else {
        print('Get more report all ...');
        page++;
        List<ReportModel>? data = await _reportRepo.getReportAll(_token!,
            page: page, limit: event.limit);
        if (data != null) {
          listReports.addAll(data);
          data.length < event.limit
              ? emit(ReportAllData(listReports, true))
              : emit(ReportAllData(listReports, false));
        } else {
          emit(ReportAllData(listReports, false));
        }
      }
    } catch (e) {
      emit(ReportAllError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }
}
