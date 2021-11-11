part of 'role_access_bloc.dart';

abstract class RoleAccessState {
  const RoleAccessState();
}

class RoleAccessInitial extends RoleAccessState {}

class GetRoleAccessLoading extends RoleAccessState {}

class RoleAccessData extends RoleAccessState {
  final List<RoleAccessModel> listRoleAccesss;
  final bool hasReachMax;
  RoleAccessData(this.listRoleAccesss, this.hasReachMax);
}

class RoleAccessSuccess extends RoleAccessState {
  final String message;
  RoleAccessSuccess(this.message);
}

class RoleAccessError extends RoleAccessState {
  final String message;
  RoleAccessError(this.message);
}

class CreateRoleAccessLoading extends RoleAccessState {}

class CreateRoleAccessSuccess extends RoleAccessState {
  final String message;
  CreateRoleAccessSuccess(this.message);
}

class CreateRoleAccessError extends RoleAccessState {
  final String message;
  CreateRoleAccessError(this.message);
}

class UpdateRoleAccessLoading extends RoleAccessState {}

class UpdateRoleAccessSuccess extends RoleAccessState {
  final String message;
  UpdateRoleAccessSuccess(this.message);
}

class UpdateRoleAccessError extends RoleAccessState {
  final String message;
  UpdateRoleAccessError(this.message);
}

class DeleteRoleAccessLoading extends RoleAccessState {}

class DeleteRoleAccessSuccess extends RoleAccessState {
  final String message;
  DeleteRoleAccessSuccess(this.message);
}

class DeleteRoleAccessError extends RoleAccessState {
  final String message;
  DeleteRoleAccessError(this.message);
}
