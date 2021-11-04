import 'package:bloc/bloc.dart';
import 'package:tukangku/models/employee_model.dart';
import 'package:tukangku/models/response_model.dart';
import 'package:tukangku/repositories/auth_repository.dart';
import 'package:tukangku/repositories/employee_repository.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeRepository _employeeRepo = EmployeeRepository();
  AuthRepository _authRepo = AuthRepository();
  List<EmployeeModel> listEmployees = [];
  int page = 1;

  EmployeeBloc() : super(EmployeeInitial()) {
    on<GetEmployee>(_getEmployee);
    on<CreateEmployee>(_createEmployee);
    on<UpdateEmployee>(_updateEmployee);
    on<DeleteEmployee>(_deleteEmployee);
  }

  Future _getEmployee(GetEmployee event, Emitter<EmployeeState> emit) async {
    try {
      String? _token = await _authRepo.hasToken();
      if (event.isInit) {
        print('Get init Banner ...');
        page = 1;
        emit(GetEmployeeLoading());
        List<EmployeeModel>? data = await _employeeRepo.getEmployees(_token!,
            page: page, limit: event.limit);
        if (data != null) {
          listEmployees = data;
          data.length < event.limit
              ? emit(EmployeeData(listEmployees, true))
              : emit(EmployeeData(listEmployees, false));
        } else {
          emit(EmployeeData(listEmployees, false));
        }
      } else {
        print('Get more employee ...');
        page++;
        List<EmployeeModel>? data = await _employeeRepo.getEmployees(_token!,
            page: page, limit: event.limit);
        if (data != null) {
          listEmployees.addAll(data);
          data.length < event.limit
              ? emit(EmployeeData(listEmployees, true))
              : emit(EmployeeData(listEmployees, false));
        } else {
          emit(EmployeeData(listEmployees, false));
        }
      }
    } catch (e) {
      emit(EmployeeError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }

  Future _createEmployee(
      CreateEmployee event, Emitter<EmployeeState> emit) async {
    emit(CreateEmployeeLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _employeeRepo.createEmployee(_token, event.employeeModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(CreateEmployeeSuccess(responseModel.message ?? ''));
          } else {
            emit(CreateEmployeeError(responseModel.message ?? ''));
          }
        } else {
          emit(CreateEmployeeError(
              'Tambah tukang gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(CreateEmployeeError('Tambah tukang gagal, silahkan coba kembali'));
    }
  }

  Future _updateEmployee(
      UpdateEmployee event, Emitter<EmployeeState> emit) async {
    emit(UpdateEmployeeLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _employeeRepo.updateEmployee(_token, event.employeeModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(UpdateEmployeeSuccess(responseModel.message ?? ''));
          } else {
            emit(UpdateEmployeeError(responseModel.message ?? ''));
          }
        } else {
          emit(UpdateEmployeeError(
              'Update tukang gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(UpdateEmployeeError('Update tukang gagal, silahkan coba kembali'));
    }
  }

  Future _deleteEmployee(
      DeleteEmployee event, Emitter<EmployeeState> emit) async {
    emit(DeleteEmployeeLoading());
    try {
      String? _token = await _authRepo.hasToken();
      if (_token != null) {
        ResponseModel? responseModel =
            await _employeeRepo.deleteEmployee(_token, event.employeeModel);
        if (responseModel != null) {
          if (responseModel.status == 'success') {
            emit(DeleteEmployeeSuccess(responseModel.message ?? ''));
          } else {
            emit(DeleteEmployeeError(responseModel.message ?? ''));
          }
        } else {
          emit(DeleteEmployeeError(
              'Delete tukang gagal, silahkan coba kembali'));
        }
      }
    } catch (e) {
      print(e.toString());
      emit(DeleteEmployeeError('Delete tukang gagal, silahkan coba kembali'));
    }
  }
}
