part of 'role_permission_bloc.dart';

abstract class RolePermissionState {
  const RolePermissionState();
}

class RolePermissionInitial extends RolePermissionState {}

class GetRolePermissionLoading extends RolePermissionState {}

class RolePermissionData extends RolePermissionState {
  final List<RolePermissionModel> listRolePermissions;
  final bool hasReachMax;
  RolePermissionData(this.listRolePermissions, this.hasReachMax);
}

class RolePermissionSuccess extends RolePermissionState {
  final String message;
  RolePermissionSuccess(this.message);
}

class RolePermissionError extends RolePermissionState {
  final String message;
  RolePermissionError(this.message);
}

class CreateRolePermissionLoading extends RolePermissionState {}

class CreateRolePermissionSuccess extends RolePermissionState {
  final String message;
  CreateRolePermissionSuccess(this.message);
}

class CreateRolePermissionError extends RolePermissionState {
  final String message;
  CreateRolePermissionError(this.message);
}

class UpdateRolePermissionLoading extends RolePermissionState {}

class UpdateRolePermissionSuccess extends RolePermissionState {
  final String message;
  UpdateRolePermissionSuccess(this.message);
}

class UpdateRolePermissionError extends RolePermissionState {
  final String message;
  UpdateRolePermissionError(this.message);
}

class DeleteRolePermissionLoading extends RolePermissionState {}

class DeleteRolePermissionSuccess extends RolePermissionState {
  final String message;
  DeleteRolePermissionSuccess(this.message);
}

class DeleteRolePermissionError extends RolePermissionState {
  final String message;
  DeleteRolePermissionError(this.message);
}
