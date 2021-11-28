import 'package:bloc/bloc.dart';
import 'package:tukangku/models/history_model.dart';
import 'package:tukangku/models/report_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/history_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  AuthRepository _authRepo = AuthRepository();
  HistoryRepository _historyRepo = HistoryRepository();
  List<HistoryEmployeeModel> listHitoryEmployees = [];
  List<ReportModel> listHitoryConsumens = [];
  int page = 1;

  HistoryBloc() : super(HistoryInitial()) {
    on<GetHistoryEmployee>(_getHistoryEmployee);
    on<GetHistoryConsumen>(_getHistoryConsumen);
  }

  Future _getHistoryEmployee(
      GetHistoryEmployee event, Emitter<HistoryState> emit) async {
    try {
      String? _token = await _authRepo.hasToken();
      if (event.isInit) {
        print('Get init history employee ...');
        page = 1;
        emit(GetHistoryEmployeeLoading());
        List<HistoryEmployeeModel>? data = await _historyRepo
            .getHistoryEmployee(_token!, page: page, limit: event.limit);
        if (data != null) {
          listHitoryEmployees = data;
          data.length < event.limit
              ? emit(HistoryEmployeeData(listHitoryEmployees, true))
              : emit(HistoryEmployeeData(listHitoryEmployees, false));
        } else {
          emit(HistoryEmployeeData(listHitoryEmployees, false));
        }
      } else {
        print('Get more history employee ...');
        page++;
        List<HistoryEmployeeModel>? data = await _historyRepo
            .getHistoryEmployee(_token!, page: page, limit: event.limit);
        if (data != null) {
          listHitoryEmployees.addAll(data);
          data.length < event.limit
              ? emit(HistoryEmployeeData(listHitoryEmployees, true))
              : emit(HistoryEmployeeData(listHitoryEmployees, false));
        } else {
          emit(HistoryEmployeeData(listHitoryEmployees, false));
        }
      }
    } catch (e) {
      emit(HistoryEmployeeError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _getHistoryConsumen(
      GetHistoryConsumen event, Emitter<HistoryState> emit) async {
    try {
      String? _token = await _authRepo.hasToken();
      if (event.isInit) {
        print('Get init history consumen ...');
        page = 1;
        emit(GetHistoryConsumenLoading());
        List<ReportModel>? data = await _historyRepo.getHistoryConsumen(_token!,
            page: page, limit: event.limit);
        if (data != null) {
          listHitoryConsumens = data;
          data.length < event.limit
              ? emit(HistoryConsumenData(listHitoryConsumens, true))
              : emit(HistoryConsumenData(listHitoryConsumens, false));
        } else {
          emit(HistoryConsumenData(listHitoryConsumens, false));
        }
      } else {
        print('Get more history consumen ...');
        page++;
        List<ReportModel>? data = await _historyRepo.getHistoryConsumen(_token!,
            page: page, limit: event.limit);
        if (data != null) {
          listHitoryConsumens.addAll(data);
          data.length < event.limit
              ? emit(HistoryConsumenData(listHitoryConsumens, true))
              : emit(HistoryConsumenData(listHitoryConsumens, false));
        } else {
          emit(HistoryConsumenData(listHitoryConsumens, false));
        }
      }
    } catch (e) {
      emit(HistoryConsumenError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }
}
