part of 'employee_bloc.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();
  
  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}
