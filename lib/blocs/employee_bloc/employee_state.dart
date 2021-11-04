part of 'employee_bloc.dart';

abstract class EmployeeState {
  const EmployeeState();
}

class EmployeeInitial extends EmployeeState {}

class GetEmployeeLoading extends EmployeeState {}

class EmployeeData extends EmployeeState {
  final List<EmployeeModel> listEmployees;
  final bool hasReachMax;
  EmployeeData(this.listEmployees, this.hasReachMax);
}

class EmployeeSuccess extends EmployeeState {
  final String message;
  EmployeeSuccess(this.message);
}

class EmployeeError extends EmployeeState {
  final String message;
  EmployeeError(this.message);
}

class CreateEmployeeLoading extends EmployeeState {}

class CreateEmployeeSuccess extends EmployeeState {
  final String message;
  CreateEmployeeSuccess(this.message);
}

class CreateEmployeeError extends EmployeeState {
  final String message;
  CreateEmployeeError(this.message);
}

class UpdateEmployeeLoading extends EmployeeState {}

class UpdateEmployeeSuccess extends EmployeeState {
  final String message;
  UpdateEmployeeSuccess(this.message);
}

class UpdateEmployeeError extends EmployeeState {
  final String message;
  UpdateEmployeeError(this.message);
}

class DeleteEmployeeLoading extends EmployeeState {}

class DeleteEmployeeSuccess extends EmployeeState {
  final String message;
  DeleteEmployeeSuccess(this.message);
}

class DeleteEmployeeError extends EmployeeState {
  final String message;
  DeleteEmployeeError(this.message);
}
