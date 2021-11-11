import 'package:bloc/bloc.dart';
import 'package:tukangku/models/log_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/log_repository.dart';

part 'log_event.dart';
part 'log_state.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  AuthRepository _authRepo = AuthRepository();
  LogRepository _logRepo = LogRepository();
  List<UserLogModel> listUserLogs = [];
  List<GPSLogModel> listGPSLogs = [];
  int page = 1;

  LogBloc() : super(LogInitial()) {
    on<GetUserLog>(_getUserLog);
    on<GetGPSLog>(_getGPSLog);
  }

  Future _getUserLog(GetUserLog event, Emitter<LogState> emit) async {
    try {
      String? _token = await _authRepo.hasToken();
      if (event.isInit) {
        print('Get init user logs ...');
        page = 1;
        emit(GetUserLogLoading());
        List<UserLogModel>? data =
            await _logRepo.getUserLogs(_token!, page: page, limit: event.limit);
        if (data != null) {
          listUserLogs = data;
          data.length < event.limit
              ? emit(UserLogData(listUserLogs, true))
              : emit(UserLogData(listUserLogs, false));
        } else {
          emit(UserLogData(listUserLogs, false));
        }
      } else {
        print('Get more user logs ...');
        page++;
        List<UserLogModel>? data =
            await _logRepo.getUserLogs(_token!, page: page, limit: event.limit);
        if (data != null) {
          listUserLogs.addAll(data);
          data.length < event.limit
              ? emit(UserLogData(listUserLogs, true))
              : emit(UserLogData(listUserLogs, false));
        } else {
          emit(UserLogData(listUserLogs, false));
        }
      }
    } catch (e) {
      emit(UserLogError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _getGPSLog(GetGPSLog event, Emitter<LogState> emit) async {
    try {
      if (event.isInit) {
        print('Get init gps logs ...');
        page = 1;
        emit(GetGPSLogLoading());
        List<GPSLogModel>? data =
            await _logRepo.getGPSLogs(page: page, limit: event.limit);
        if (data != null) {
          listGPSLogs = data;
          data.length < event.limit
              ? emit(GPSLogData(listGPSLogs, true))
              : emit(GPSLogData(listGPSLogs, false));
        } else {
          emit(GPSLogData(listGPSLogs, false));
        }
      } else {
        print('Get more gps logs ...');
        page++;
        List<GPSLogModel>? data =
            await _logRepo.getGPSLogs(page: page, limit: event.limit);
        if (data != null) {
          listGPSLogs.addAll(data);
          data.length < event.limit
              ? emit(GPSLogData(listGPSLogs, true))
              : emit(GPSLogData(listGPSLogs, false));
        } else {
          emit(GPSLogData(listGPSLogs, false));
        }
      }
    } catch (e) {
      emit(GPSLogError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }
}
