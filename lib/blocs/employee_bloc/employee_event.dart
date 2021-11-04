part of 'employee_bloc.dart';

abstract class EmployeeEvent {
  const EmployeeEvent();
}

class GetEmployee extends EmployeeEvent {
  final int limit;
  final bool isInit;
  GetEmployee(this.limit, this.isInit);
}

class CreateEmployee extends EmployeeEvent {
  final EmployeeModel employeeModel;
  CreateEmployee(this.employeeModel);
}

class UpdateEmployee extends EmployeeEvent {
  final EmployeeModel employeeModel;
  UpdateEmployee(this.employeeModel);
}

class DeleteEmployee extends EmployeeEvent {
  final EmployeeModel employeeModel;
  DeleteEmployee(this.employeeModel);
}
